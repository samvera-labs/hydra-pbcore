module HydraPbcore::Methods

  # Used to delete nodes based on their OM term defintion.
  #
  # Default behavior is to delete on the xml defining the term. In
  # some cases, terms can have dependent xml that is part of the term's
  # parent. For example, pbcoreReation templates use the 
  # pbcoreRelation xml node to define a term, however the term's 
  # definition is dependent on the xml inside pbcoreRelation. When
  # we delete the term, the pbcoreRelation has to go along with it.
  #
  # In that case, we can pass the option:
  #   :include_parent? => true
  # Which will delete the term as well as its closest parent
  def remove_node(type, index = 0, opts = {})
    opts[:include_parent?] ? self.find_by_terms(type.to_sym).slice(index.to_i).parent.remove : self.find_by_terms(type.to_sym).slice(index.to_i).remove
  end


  def remove_node_with_parent type, index = 0

  end

  # Returns a new Nokogiri::XML object with the contents of self, plus any additional instanstations,
  # reordered and repackaged as a  valid pbcore xml document.
  #
  # The original xml from the datastream is copied to a new Nokogiri object, then each node
  # is added--in correct order--to a new blank, valid pbcore xml document.  If additional
  # instantiations are passed in as an array, those are correctly reordered as well, and
  # included in the document
  def to_pbcore_xml included_instantiations = Array.new, instantiations = Array.new

    # Reorder any included instantations
    included_instantiations.each do |i|
      original_inst = Nokogiri::XML(i.to_xml)
      new_inst = Nokogiri::XML("<pbcoreInstantiation/>")
      HydraPbcore::InstantiationNodes.each do |node|
        original_inst.search(node).each do |n|
          new_inst.root.add_child(n)
        end
      end
      instantiations << new_inst
    end

    # Reorder the document
    original = Nokogiri::XML(self.to_xml)
    new_doc = HydraPbcore.blank
    HydraPbcore::DocumentNodes.each do |node|
      original.search(node).each do |n|
        new_doc.root.add_child(n)
      end
      if node.match("pbcoreInstantiation") && !instantiations.empty?
        instantiations.collect { |i| new_doc.root.add_child(i.root.to_xml) }
      end
    end
    return new_doc
  end

  # Validates a PBCore document against an xsd
  # Returns an array of errors -- an empty array means it's valid
  def valid?
    xsd = Nokogiri::XML::Schema(open("http://pbcore.org/xsd/pbcore-2.0.xsd"))
    xsd.validate(self.to_pbcore_xml)
  end

  # Returns the 4-digit year from a string
  def get_year(s)
    begin
      return DateTime.parse(s).year.to_s
    rescue
      if s.match(/^\d\d\d\d$/)
        return s.to_s
      elsif s.match(/^(\d\d\d\d)-\d\d$/)
        return $1.to_s
      else
        return nil
      end
    end
  end

  # Overrides Solrizer::XML::TerminologyBasedSolrizer.to_solr to use our own mapper
  def to_solr(solr_doc = Hash.new)
    Solrizer.default_field_mapper = HydraPbcore::Mapper.new
    super(solr_doc)
  end

end