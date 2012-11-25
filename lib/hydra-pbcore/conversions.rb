# Methods for converting HydraPbcore 1.x datastreams to HydraPbcore 2.x datastreams

module HydraPbcore::Conversions

  # Converts a HydraPbcore::Datastream::Deprecated::Document to a HydraPbcore::Datastream::Document
  # Simply removes the pbcoreInstantiation node
  def to_document
    raise "only works with HydraPbcore::Datastream::Deprecated::Document" unless self.kind_of?(HydraPbcore::Datastream::Deprecated::Document)
    self.remove_node(:pbcoreInstantiation)
    self.dirty = true
  end

  # Extracts the instantation from a HydraPbcore::Datastream::Deprecated::Document and returns
  # a physical HydraPbcore::Datastream::Instantion
  # This process includes:
  # - remove all instantiationRelation nodes (these should be processed prior to removal)
  # - add source="PBCore instantiationColors" to instantiationColors node
  # - extract only the pbcoreInstantiation node
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

end