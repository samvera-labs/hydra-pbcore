require 'spec_helper'

describe "Converting" do

  before :all do
    class FakeDocument
      include HydraPbcore::Conversions
    end
    @fake = FakeDocument.new
  end
  
  describe "HydraPbcore::Datastream::Deprecated::Document to HydraPbcore::Datastream::Document" do
    it "should return a valid pbcore document" do
      doc = HydraPbcore::Datastream::Deprecated::Document.from_xml(integration_fixture "document_rrhof_524.xml")
      doc.to_document
      save_template doc.to_xml, "converted_rrhof_524.xml"
      equivalent_xml_files("converted_rrhof_524.xml").should be_true
    end
    it "should raise an error with the wrong class" do
      lambda { @fake.to_document }.should raise_error
    end
  end

  describe "HydraPbcore::Datastream::Deprecated::Document to HydraPbcore::Datastream::Instantiation" do
    it "should return a physical instantation from an existing document" do
      doc  = HydraPbcore::Datastream::Deprecated::Document.from_xml(integration_fixture "document_rrhof_524.xml")
      inst = doc.to_physical_instantiation
      inst.should be_kind_of HydraPbcore::Datastream::Instantiation
      save_template inst.to_xml, "converted_rrhof_524_instantiation.xml"
      equivalent_xml_files("converted_rrhof_524_instantiation.xml").should be_true
    end
    it "should raise an error with the wrong class" do
      lambda { @fake.to_document }.should raise_error
    end
  end

  describe "HydraPbcore::Datastream::Deprecated::Instantiation to HydraPbcore::Datastream::Instantiation" do
    it "should return a valid instantation" do
      inst = HydraPbcore::Datastream::Deprecated::Instantiation.from_xml(integration_fixture "instantiation_rrhof_1184.xml")
      inst.to_instantiation
      save_template inst.to_xml, "converted_instantiation_rrhof_1184.xml"
      equivalent_xml_files("converted_instantiation_rrhof_1184.xml").should be_true
    end
    it "should raise an error with the wrong class" do
      lambda { @fake.to_document }.should raise_error
    end
  end

  describe "HydraPbcore::Datastream::Deprecated::DigitalDocument to HydraPbcore::Datastream::Document" do
    it "should clean up invalid xml" do
      pending "Additional methods needed"
      doc = HydraPbcore::Datastream::Deprecated::DigitalDocument.from_xml(integration_fixture "digital_document_rrhof_1904.xml")
      doc.to_document
      save_template doc.to_xml, "converted_digital_document_rrhof_1904"
    end
  end

end