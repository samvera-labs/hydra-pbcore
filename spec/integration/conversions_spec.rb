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
      tmp_file_should_match_exemplar("converted_rrhof_524.xml")
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
      tmp_file_should_match_exemplar("converted_rrhof_524_instantiation.xml")
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
      tmp_file_should_match_exemplar("converted_instantiation_rrhof_1184.xml")
    end
    it "should raise an error with the wrong class" do
      lambda { @fake.to_document }.should raise_error
    end
  end

  describe "#clean_document" do
    it "should correct invalid pbcoreDocuments" do
      ["document_rrhof_524.xml","document_rrhof_2439.xml"].each do |file|
        doc = HydraPbcore::Datastream::Deprecated::Document.from_xml(integration_fixture file)
        doc.to_document
        doc.clean_document
        save_template doc.to_xml, ("converted_"+file)
        tmp_file_should_match_exemplar(("converted_"+file))
        save_template doc.to_pbcore_xml, "valid_pbcore.xml"
        doc.valid?.should == []
      end
    end
  end

  describe "#clean_digital_document" do
    it "should correct invalid pbcoreDigitalDocuments" do
      ["digital_document_rrhof_1904.xml","digital_document_rrhof_2405.xml"].each do |file|
        doc = HydraPbcore::Datastream::Deprecated::DigitalDocument.from_xml(integration_fixture file)
        doc.clean_digital_document
        save_template doc.to_xml, ("converted_"+file)
        tmp_file_should_match_exemplar(("converted_"+file))
        save_template doc.to_pbcore_xml, "valid_pbcore.xml"
        doc.valid?.should == []
      end
    end
  end

end
