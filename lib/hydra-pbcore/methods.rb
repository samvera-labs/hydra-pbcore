module HydraPbcore::Methods

  def remove_node(type, index = 0)
    self.find_by_terms(type.to_sym).slice(index.to_i).remove
  end

  # Returns a new Nokogiri::XML object with the contents of self reordered and repackaged as a 
  # valid pbcore xml document.
  #
  # The original xml from the datastream is copied to a new Nokogiri object, then each node
  # is added--in correct order--to a new blank, valid pbcore xml document.
  def to_pbcore_xml
    original = Nokogiri::XML(self.to_xml)
    new_doc = HydraPbcore.blank
    HydraPbcore::DocumentNodes.each do |node|
      original.search(node).each do |n|
        new_doc.root.add_child(n)
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

  # Overrides Solrizer::XML::TerminologyBasedSolrizer.to_solr to use our own mapper
  def to_solr(solr_doc = Hash.new)
    Solrizer.default_field_mapper = HydraPbcore::Mapper.new
    super(solr_doc)
  end

end