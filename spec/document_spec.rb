require "spec_helper"

describe HydraPbcore::Datastream::Document do

  before(:each) do
    @object_ds = HydraPbcore::Datastream::Document.new(nil, nil)
  end

  describe "::xml_template" do
    it "should match an exmplar" do
      save_template @object_ds.to_xml, "document_template.xml"
      equivalent_xml_files("document_template.xml").should be_true
    end
  end

  describe "#update_indexed_attributes" do
    it "should update the intitial fields" do
      [
        [:pbc_id],
        [:main_title],
        [:alternative_title],
        [:chapter],
        [:episode],
        [:label],
        [:segment],
        [:subtitle],
        [:track],
        [:translation],
        [:summary],
        [:parts_list],
        [:lc_subject],
        [:lc_name],
        [:rh_subject],
        [:getty_genre],
        [:lc_genre],
        [:lc_subject_genre],
        [:event_series],
        [:contributor_name],
        [:contributor_role],
        [:publisher_name],
        [:publisher_role],
        [:note],
        [:rights_summary],
        [:archival_collection],
        [:archival_series],
        [:collection_number],
        [:accession_number],
      ].each do |pointer|
        test_val = random_string
        @object_ds.update_values( {pointer=>{"0"=>test_val}} )
        @object_ds.get_values(pointer).first.should == test_val
        @object_ds.get_values(pointer).length.should == 1
      end
    end

    it "should update fields requiring inserted nodes" do
      @object_ds.insert_publisher
      @object_ds.insert_contributor
      [
        [:publisher_name],
        [:publisher_role],
        [:contributor_name],
        [:contributor_role]
      ].each do |pointer|
        test_val = "#{pointer.last.to_s} value"
        @object_ds.update_indexed_attributes( {pointer=>{"0"=>test_val}} )
        @object_ds.get_values(pointer).first.should == test_val
        @object_ds.get_values(pointer).length.should == 1
      end
    end

    it "should differentiate between multiple added nodes" do
      @object_ds.insert_contributor
      @object_ds.insert_contributor
      @object_ds.update_indexed_attributes( {[:contributor_name] => { 0 => "first contributor" }} )
      @object_ds.update_indexed_attributes( {[:contributor_name] => { 1 => "second contributor" }} )
      @object_ds.update_indexed_attributes( {[:contributor_role] => { 0 => "first contributor role" }} )
      @object_ds.update_indexed_attributes( {[:contributor_role] => { 1 => "second contributor role" }} )
      @object_ds.get_values(:contributor).length.should == 2
      @object_ds.get_values(:contributor_name)[0].should == "first contributor"
      @object_ds.get_values(:contributor_name)[1].should == "second contributor"
      @object_ds.get_values(:contributor_role)[0].should == "first contributor role"
      @object_ds.get_values(:contributor_role)[1].should == "second contributor role"
    end
  end

  describe "#remove_node" do
    it "should remove a node a given type and index" do
      ["publisher", "contributor"].each do |type|
        @object_ds.send("insert_"+type)
        @object_ds.send("insert_"+type)
        @object_ds.find_by_terms(type.to_sym).count.should == 2
        @object_ds.remove_node(type.to_sym, "1")
        @object_ds.find_by_terms(type.to_sym).count.should == 1
        @object_ds.remove_node(type.to_sym, "0")
        @object_ds.find_by_terms(type.to_sym).count.should == 0
      end
    end
  end

  describe "sample" do

    before(:each) do
      # insert additional nodes
      @object_ds.insert_publisher("inserted", "inserted")
      @object_ds.insert_contributor("inserted", "inserted")
      @object_ds.insert_publisher("inserted")
      @object_ds.insert_contributor("inserted")
      @object_ds.insert_contributor
      @object_ds.insert_place("inserted")
      @object_ds.insert_date("2012-11-11")

      @object_ds.pbc_id               = "inserted"
      @object_ds.main_title           = "inserted"
      @object_ds.alternative_title    = "inserted"
      @object_ds.chapter              = "inserted"
      @object_ds.episode              = "inserted"
      @object_ds.label                = "inserted"
      @object_ds.segment              = "inserted"
      @object_ds.subtitle             = "inserted"
      @object_ds.track                = "inserted"
      @object_ds.translation          = "inserted"
      @object_ds.summary              = "inserted"
      @object_ds.parts_list           = "inserted"
      @object_ds.lc_subject           = "inserted"
      @object_ds.lc_name              = "inserted"
      @object_ds.rh_subject           = "inserted"
      @object_ds.getty_genre          = "inserted"
      @object_ds.lc_genre             = "inserted"
      @object_ds.lc_subject_genre     = "inserted"
      @object_ds.event_series         = "inserted"
      @object_ds.contributor_name     = "inserted"
      @object_ds.contributor_role     = "inserted"
      @object_ds.publisher_name       = "inserted"
      @object_ds.publisher_role       = "inserted"
      @object_ds.note                 = "inserted"
      @object_ds.rights_summary       = "inserted"
      @object_ds.archival_collection  = "inserted"
      @object_ds.archival_series      = "inserted"
      @object_ds.collection_number    = "inserted"
      @object_ds.accession_number     = "inserted"
    end

    it "solr document should match an exmplar" do
      save_template @object_ds.to_solr.to_xml, "document_solr.xml"
      equivalent_xml_files("document_solr.xml").should be_true
    end

    describe "solr dates" do
      it "should be indexed for display" do
        @object_ds.to_solr["event_date_display"].should == ["2012-11-11"]
      end

      it "should be converted to ISO 8601" do
        @object_ds.to_solr["event_date_dt"].should == ["2012-11-11T00:00:00Z"]
      end

      it "should not be searchable as strings" do
        @object_ds.to_solr["event_date_t"].should be_nil
      end
    end

    it "xml document should match an exmplar" do
      save_template @object_ds.to_xml, "document.xml"
      equivalent_xml_files("document.xml").should be_true
    end

    it "xml document should validate against the PBCore schema" do
      save_template @object_ds.to_pbcore_xml, "document_valid.xml"
      @object_ds.valid?.should == []
    end
  end  

end
