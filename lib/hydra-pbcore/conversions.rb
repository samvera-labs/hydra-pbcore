# Methods for converting HydraPbcore 1.x datastreams to HydraPbcore 2.x datastreams
#
# Verion 1.x of the HydraPbcore gem uses two kinds of pbcoreDocuments, one which includes an instantation
# and one which does not.  Version 2 of the gem refactors these so that there
# is only one kind of pbcoreDocument and two kinds of instatiations.  This offers greater flexibility
# as any number of instantiations may be attached to a document.  Instatntiations come in two types,
# one is physical, meaning it represents a tape or other
# tangible object on which the video content resides, while the other kind is
# digital, representing a video file.
#
# These methods attempt to correct invalid or inconsistent xml created using the first version of the 
# gem.

module HydraPbcore::Conversions

  # Converts a HydraPbcore::Datastream::Deprecated::Document to a HydraPbcore::Datastream::Document
  # - the existing pbcoreInstantiation node is removed
  # - any pbcoreRelation or pbcoreRelationIdentifier is removed except for terms identifying "Event Series"
  def to_document
    raise "only works with HydraPbcore::Datastream::Deprecated::Document" unless self.kind_of?(HydraPbcore::Datastream::Deprecated::Document)
    self.remove_node(:pbcoreInstantiation)
    self.dirty = true
  end

  # Extracts the instantation from a HydraPbcore::Datastream::Deprecated::Document and returns
  # a physical HydraPbcore::Datastream::Instantion
  # - removes all instantiationRelation nodes
  # - adds source="PBCore instantiationColors" to instantiationColors node
  # - extracts the pbcoreInstantiation node and returns new Instantiation object
  def to_physical_instantiation(xml = self.ng_xml)
    raise "only works with HydraPbcore::Datastream::Deprecated::Document" unless self.kind_of?(HydraPbcore::Datastream::Deprecated::Document)
    xml.search("//instantiationRelation").each do |node|  
      node.remove
    end
    xml.search("//instantiationColors").first["source"] = "PBCore instantiationColors"
    inst_xml = xml.xpath("//pbcoreInstantiation")
    HydraPbcore::Datastream::Instantiation.from_xml(inst_xml.to_xml)
  end

  # Converts a HydraPbcore::Datastream::Deprecated::Instantiation to a HydraPbcore::Datastream::Instantiation
  # Modifies the exiting xml to exclude any parent nodes of the pbcoreInstantiation node
  def to_instantiation
    raise "only works with HydraPbcore::Datastream::Deprecated::Instantiation" unless self.kind_of?(HydraPbcore::Datastream::Deprecated::Instantiation)
    self.ng_xml = self.ng_xml.xpath("//pbcoreInstantiation").to_xml
  end

  # Corrects errors in HydraPbcore::Datastream::Deprecated::Document and HydraPbcore::Datastream::Deprecated::DigitalDocument
  # - removes all pbcoreRelation nodes, except those that define event_series
  # - removes orphaned pbcoreRelationIdentifier nodes
  # - corrects invalid usage of event_place and event_series terms
  #
  # Note: Since pbcoreRelation is used to indicated archival collection and series, this information should be copied to another kind
  # of datastream using an RDF relationship in Hydra.
  def clean_document(xml = self.ng_xml)
    xml.search("//pbcoreRelation").each do |node|  
      node.remove unless is_event_series?(node)
    end
    xml.search("/pbcoreDescriptionDocument/pbcoreRelationIdentifier").collect {|n| n.remove}
    xml.search("//pbcoreCoverage").each do |node|
      node.children.each do |c|
        if c.attribute("annotation").nil? and c.name == "coverage"
          self.send(("insert_"+coverage_type(node)), c.text)
          c.remove
        end
      end
    end
  end

  # Determines if the given node defines an event_series term
  def is_event_series?(node)
    unless node.at_xpath("pbcoreRelationIdentifier").nil?
      if node.at_xpath("pbcoreRelationIdentifier").attribute("annotation").to_s == "Event Series"
        return true
      end
    end
  end

  # Determines if a coverage node that has no annotation attribute should be either an event_date term or an event_date term.
  # Returns the first instance of an annotation attribute, processing it so that may be sent directly to 
  # the datastream as a method.
  def coverage_type(node)
    node.children.each do |c|
      return c.attribute("annotation").to_s.split.last.downcase unless c.attribute("annotation").nil?
    end
  end


end