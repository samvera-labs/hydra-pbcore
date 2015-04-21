require "spec_helper"
require "pry"

describe HydraPbcore::Datastream::Document do

  before(:each) do
    @object_ds = HydraPbcore::Datastream::Document.new(nil, nil)
  end

  describe "::xml_template" do
    it "should match an exmplar" do
      save_template @object_ds.to_xml, "document_template.xml"
      tmp_file_should_match_exemplar("document_template.xml")
    end
  end

  describe "#update_indexed_attributes" do
    it "should update the intitial fields" do
      [
        [:pbc_id],
        [:title],
        [:alternative_title],
        [:chapter],
        [:episode],
        [:label],
        [:segment],
        [:subtitle],
        [:track],
        [:translation],
        [:summary],
        [:asset_date],
        [:contents],
        [:lc_subject],
        [:lc_name],
        [:rh_subject],
        [:getty_genre],
        [:lc_genre],
        [:lc_subject_genre],
        [:series],
        [:creator_name],
        [:creator_role],
        [:contributor_name],
        [:contributor_role],
        [:publisher_name],
        [:publisher_role],
        [:note],
        [:asset_type],
        [:rights_summary],
        [:collection],
        [:additional_collection],
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
      @object_ds.insert_creator
      @object_ds.insert_publisher
      @object_ds.insert_contributor
      [
        [:creator_name],
        [:creator_role],
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

    describe "#is_part_of" do
      it "includes archival colletions" do
        @object_ds = HydraPbcore::Datastream::Document.new(nil, nil)
        @object_ds.is_part_of("My Collection", {:annotation => 'Archival Collection'})
        @object_ds.collection.should == ['My Collection']
      end
      it "includes event series" do
        @object_ds.is_part_of("My event", {:annotation => 'Event Series'})
        @object_ds.series.should == ['My event']
      end
      it "includes archival series" do
        @object_ds.is_part_of("My series", {:annotation => 'Archival Series'})
        @object_ds.archival_series.should == ['My series']
      end
      it "includes accession numbers" do
        @object_ds.is_part_of("My Acces Num", {:annotation => 'Accession Number'})
        @object_ds.accession_number.should == ['My Acces Num']
      end
      it "includes additional colletions" do
        @object_ds.is_part_of("Some other collection", {:annotation => 'Additional Collection'})
        @object_ds.additional_collection.should == ['Some other collection']
      end
    end


    it "should differentiate between multiple added nodes" do
      @object_ds.insert_contributor("first contributor", "first contributor role")
      @object_ds.insert_contributor("second contributor", "second contributor role")
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
      @object_ds.insert_identifier("inserted", "PID")
      @object_ds.insert_publisher("inserted", "inserted")
      @object_ds.insert_contributor("inserted", "inserted")
      @object_ds.insert_publisher("inserted")
      @object_ds.insert_contributor("inserted")
      @object_ds.insert_contributor
      @object_ds.insert_place("inserted")
      @object_ds.insert_date("2012-11-11")
      @object_ds.insert_date("2012-11-12")

      @object_ds.is_part_of("inserted", {:annotation => 'Archival Collection'})
      @object_ds.is_part_of("inserted", {:annotation => 'Event Series'})
      @object_ds.is_part_of("inserted", {:annotation => 'Archival Series'})
      @object_ds.is_part_of("inserted", {:annotation => 'Accession Number'})
      @object_ds.is_part_of("inserted", {:annotation => 'Collection Number'})
      @object_ds.is_part_of("inserted", {:annotation => 'Additional Collection'})

      @object_ds.title                = "inserted"
      @object_ds.alternative_title    = "inserted"
      @object_ds.chapter              = "inserted"
      @object_ds.episode              = "inserted"
      @object_ds.label                = "inserted"
      @object_ds.segment              = "inserted"
      @object_ds.subtitle             = "inserted"
      @object_ds.track                = "inserted"
      @object_ds.translation          = "inserted"
      @object_ds.summary              = "inserted"
      @object_ds.contents             = "inserted"
      @object_ds.lc_subject           = "inserted"
      @object_ds.lc_name              = "inserted"
      @object_ds.rh_subject           = "inserted"
      @object_ds.getty_genre          = "inserted"
      @object_ds.lc_genre             = "inserted"
      @object_ds.lc_subject_genre     = "inserted"
      @object_ds.series               = "inserted"
      @object_ds.note                 = "inserted"
      @object_ds.rights_summary       = "inserted"
      @object_ds.asset_type           = "Scene"
    end

    it "solr document should match an exemplar" do
      save_template @object_ds.to_solr.to_xml, "document_solr.xml"
      tmp_file_should_match_exemplar("document_solr.xml")
    end

    describe "solr dates" do
      it "should be indexed for display" do
        @object_ds.to_solr["event_date_ssm"].should == ["2012-11-11", "2012-11-12"]
      end

      it "should be converted to ISO 8601" do
        @object_ds.to_solr["event_date_dtsim"].should == ["2012-11-11T00:00:00Z", "2012-11-12T00:00:00Z"]
      end

      it "should not be searchable as strings" do
        @object_ds.to_solr["event_date_t"].should be_nil
      end
    end

    it "xml document should match an exmplar" do
      save_template @object_ds.to_xml, "document.xml"
      tmp_file_should_match_exemplar("document.xml")
    end

    it "xml document should validate against the PBCore schema" do
      save_template @object_ds.to_pbcore_xml, "document_valid.xml"
      @object_ds.valid?.should == []
    end

    describe "xml document with instantiations" do

      before(:each) do
        @digital  = HydraPbcore::Datastream::Instantiation.new(nil, nil)
        @digital.define :digital
        @physical = HydraPbcore::Datastream::Instantiation.new(nil, nil)
        @physical.define :physical
      end

      it "should validate against the PBCore schema" do
        save_template @object_ds.to_pbcore_xml([@digital, @physical]), "document_with_instantiations_valid.xml"
        expect(HydraPbcore.is_valid?(Nokogiri::XML(sample("document_with_instantiations_valid.xml")))).to eq true
      end

    end

  end

  describe "solrization" do

    before :each do
      @ds = HydraPbcore::Datastream::Document.new(nil, nil)
    end

    it "should not create duplicate terms for contributor fields" do
      @ds.insert_contributor("foo", "bar")
      @ds.to_solr["contributor_name_sim"].should == ["foo"]
    end

    it "should not create duplicate terms for creator fields" do
      @ds.insert_creator("foo", "bar")
      @ds.to_solr["creator_name_sim"].should == ["foo"]
    end

    describe "of dates" do

      it "creates dateable and displayable fields for complete dates" do
        @ds.insert_date("1898-11-12")
        @ds.to_solr["event_date_dtsim"].should == ["1898-11-12T00:00:00Z"]
        @ds.to_solr["event_date_ssm"].should == ["1898-11-12"]
      end

      it "creates only displayable fields for dates without day" do
        @ds.insert_date("1911-07")
        @ds.to_solr["event_date_dtsim"].should be_empty
        @ds.to_solr["event_date_ssm"].should == ["1911-07"]
      end

      it "creates only displayable fields for dates without day and month" do
        @ds.insert_date("1945")
        @ds.to_solr["event_date_dtsim"].should be_empty
        @ds.to_solr["event_date_ssm"].should == ["1945"]
      end

      it "creates only displayable for non-parseable dates" do
        @ds.insert_date("crap")
        @ds.to_solr["event_date_dtsim"].should be_empty
        @ds.to_solr["event_date_ssm"].should == ["crap"]
      end

    end

  end

  describe "#collection_uri" do
    it "should return the uri of the collection" do
      @object_ds.is_part_of("Collection", {:annotation => "Archival Collection", :ref => "http://foo"})
      @object_ds.collection.should == ["Collection"]
      @object_ds.collection_uri.should == ["http://foo"]
    end
    it "should update the uri of a collection" do
      @object_ds.is_part_of("Collection", {:annotation => "Archival Collection"})
      expect(@object_ds.collection_uri).to be_empty
      @object_ds.relation.collection.uri = "http://foo"
      expect(@object_ds.collection_uri).to eq ["http://foo"]
      expect(@object_ds).to be_valid
    end
  end

  describe "#collection_authority" do
    it "should return the authority of the collection" do
      @object_ds.is_part_of("Collection", {:annotation => "Archival Collection", :source => "Foo"})
      expect(@object_ds.collection).to eq ["Collection"]
      expect(@object_ds.collection_authority).to eq ["Foo"]
    end
    it "should update the authority of a collection" do
      @object_ds.is_part_of("Collection", {:annotation => "Archival Collection"})
      expect(@object_ds.collection_authority).to be_empty
      @object_ds.relation.collection.authority = "Foo!"
      expect(@object_ds.collection_authority).to eq ["Foo!"]
      expect(@object_ds).to be_valid
    end
  end

  describe "#archival_series_uri" do
    it "should return the uri of the archival_series" do
      @object_ds.is_part_of("Series", {:annotation => "Archival Series", :ref => "http://foo"})
      expect(@object_ds.archival_series).to eq ["Series"]
      expect(@object_ds.archival_series_uri).to eq ["http://foo"]
    end
    it "should update the uri of a archival_series" do
      @object_ds.is_part_of("Series", {:annotation => "Archival Series"})
      expect(@object_ds.archival_series_uri).to be_empty
      @object_ds.relation.series.uri = "http://foo"
      expect(@object_ds.archival_series_uri).to eq ["http://foo"]
      expect(@object_ds).to be_valid
    end
  end

  describe "#archival_series_authority" do
    it "should return the authority of the archival_series" do
      @object_ds.is_part_of("Series", {:annotation => "Archival Series", :source => "Foo"})
      expect(@object_ds.archival_series).to eq ["Series"]
      expect(@object_ds.archival_series_authority).to eq ["Foo"]
    end
    it "should update the authority of a archival_series" do
      @object_ds.is_part_of("Series", {:annotation => "Archival Series"})
      expect(@object_ds.archival_series_authority).to be_empty
      @object_ds.relation.series.authority = "Foo!"
      expect(@object_ds.archival_series_authority).to eq ["Foo!"]
      expect(@object_ds).to be_valid
    end
  end

end
