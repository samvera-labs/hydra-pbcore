require "spec_helper"

describe HydraPbcore::Datastream::Instantiation do

  before(:each) do
    @digital  = HydraPbcore::Datastream::Instantiation.new(nil, 'test1')
    @digital.define :digital
    @physical = HydraPbcore::Datastream::Instantiation.new(nil, 'test2')
    @physical.define :physical
  end

  describe "::xml_template" do
    it "should have a blank default xml template" do
      expect(HydraPbcore::Datastream::Instantiation.xml_template.text).to eq ''
    end
  end

  describe "digital instantiaions" do
    it "should have these fields defined" do
      [
        [:name],
        [:location],
        [:date],
        [:generation],
        [:media_type],
        [:file_format],
        [:size],
        [:size_units],
        [:colors],
        [:duration],
        [:rights_summary],
        [:note],
        [:checksum_type],
        [:checksum_value],
        [:device],
        [:capture_soft],
        [:trans_soft],
        [:operator],
        [:trans_note],
        [:vendor],
        [:condition],
        [:cleaning],
        [:color_space],
        [:chroma],
        [:video_standard],
        [:video_encoding],
        [:video_bit_rate],
        [:video_bit_rate_units],
        [:frame_rate],
        [:frame_size],
        [:video_bit_depth],
        [:aspect_ratio],
        [:audio_standard],
        [:audio_encoding],
        [:audio_bit_rate],
        [:audio_bit_rate_units],
        [:audio_sample_rate],
        [:audio_sample_rate_units],
        [:audio_bit_depth],
        [:audio_channels],
      ].each do |pointer|
        test_val = random_string
        @digital.update_indexed_attributes( {pointer=>{"0"=>test_val}} )
        expect(@digital.get_values(pointer).first).to eq test_val
        expect(@digital.get_values(pointer).length).to eq 1
      end
    end

    it "should have default values for fields" do
      expect(@digital.media_type.first).to eq "Moving image"
      expect(@digital.colors.first).to eq "Color"
    end

    it "should have a file format and no format" do
      expect(@digital.file_format).to eq [""]
      expect(@digital.format).to eq []
    end

    it "should match an exemplar with all fields shown" do
      @digital.checksum_type  = "inserted"
      @digital.note           = "inserted"
      @digital.checksum_value = "inserted"
      @digital.device         = "inserted"
      @digital.capture_soft   = "inserted"
      @digital.trans_soft     = "inserted"
      @digital.operator       = "inserted"
      @digital.trans_note     = "inserted"
      @digital.vendor         = "inserted"
      @digital.condition      = "inserted"
      @digital.cleaning       = "inserted"
      @digital.color_space    = "inserted"
      @digital.chroma         = "inserted"
      @digital.standard       = "inserted"
      @digital.language       = "inserted"

      # insert optional nodes using sample values
      @digital.insert_next("inserted")
      @digital.insert_previous("inserted")

      save_template @digital.to_xml, "digital_instantiation.xml"
      tmp_file_should_match_exemplar("digital_instantiation.xml")
    end
 
    it "should have different essenceTrackStandard nodes" do
      @digital.video_standard = "video standard"
      @digital.audio_standard = "audio standard"
      @digital.get_values([{:pbcoreInstantiation=>0}, {:instantiationEssenceTrack=>0}, :essenceTrackStandard]).first.should == "video standard"
      @digital.get_values([{:pbcoreInstantiation=>0}, {:instantiationEssenceTrack=>1}, :essenceTrackStandard]).first.should == "audio standard"
    end

    describe "solr documents" do
      before(:each) do
        [
          "name",
          "location",
          "generation",
          "media_type",
          "file_format",
          "size",
          "size_units",
          "colors",
          "duration",
          "rights_summary",
          "note",
          "checksum_type",
          "checksum_value",
          "device",
          "capture_soft",
          "trans_soft",
          "operator",
          "trans_note",
          "vendor",
          "condition",
          "cleaning",
          "color_space",
          "chroma",
          "video_standard",
          "video_encoding",
          "video_bit_rate",
          "video_bit_rate_units",
          "frame_rate",
          "frame_size",
          "video_bit_depth",
          "aspect_ratio",
          "audio_standard",
          "audio_encoding",
          "audio_bit_rate",
          "audio_bit_rate_units",
          "audio_sample_rate",
          "audio_sample_rate_units",
          "audio_bit_depth",
          "audio_channels"
        ].each do |field|
          @digital.send("#{field}=".to_sym, field)
        end
        # Use a real date
        @digital.date = "2012-11-01"
      end

      it "should match an exmplar" do
        save_template @digital.to_solr.to_xml, "digital_instantiation_solr.xml"
        tmp_file_should_match_exemplar("digital_instantiation_solr.xml")
      end

      it "should display dates as they were entered" do
        expect(@digital.to_solr["test1__date_ssm"]).to eq ["2012-11-01"]
      end

      it "should have dates converted to ISO 8601" do
        expect(@digital.to_solr["test1__date_dtsim"]).to eq ["2012-11-01T00:00:00Z"]
      end

      # TODO: Weak test. Any non-existent key would pass.
      it "should not index dates as text" do
        expect(@digital.to_solr["test1__date_t"]).to eq nil
      end
    end
  
  end

  describe "physical instantiaions" do
    it "should have these fields defined" do
      [
        [:date],
        [:barcode],
        [:location],
        [:format],
        [:standard],
        [:media_type],
        [:generation],
        [:language],
        [:colors],
        [:rights_summary],
        [:condition_note],
        [:cleaning_note]        
      ].each do |pointer|
        test_val = random_string
        @physical.update_indexed_attributes( {pointer=>{"0"=>test_val}} )
        expect(@physical.get_values(pointer).first).to eq test_val
        expect(@physical.get_values(pointer).length).to eq 1
      end
    end

    it "should have default values for fields" do
      expect(@physical.media_type.first).to eq "Moving image"
      expect(@physical.colors.first).to eq "Color"
    end

    it "should have a format and no file format" do
      expect(@physical.file_format).to eq []
      expect(@physical.format).to eq [""]
    end

    it "should match an exmplar with all fields shown" do
      @physical.cleaning_note  = "inserted"
      @physical.condition_note = "inserted"
      save_template @physical.to_xml, "physical_instantiation.xml"
      tmp_file_should_match_exemplar("physical_instantiation.xml")
    end

    describe "solr documents" do
      before :each do
        [
          "date",
          "barcode",
          "location",
          "format",
          "standard",
          "media_type",
          "generation",
          "language",
          "colors",
          "rights_summary",
          "condition_note",
          "cleaning_note"
        ].each do |field|
          @physical.send("#{field}=".to_sym, field)
        end
        # Use a real date
        @physical.date = "2012-11-01"
      end

      it "should match an exmplar" do
        save_template @physical.to_solr.to_xml, "physical_instantiation_solr.xml"
        tmp_file_should_match_exemplar("physical_instantiation_solr.xml")
      end

      it "should display dates as they were entered" do
        expect(@physical.to_solr["test2__date_ssm"]).to eq ["2012-11-01"]
      end

      it "should have dates converted to ISO 8601" do
        expect(@physical.to_solr["test2__date_dtsim"]).to eq ["2012-11-01T00:00:00Z"]
      end

      # TODO: Weak test. Any non-existent key would pass.
      it "should not index dates as text" do
        expect(@physical.to_solr["test2__date_t"]).to eq nil
      end
    end

  end

    describe "solrization of dates" do

    before :each do
      @ds = HydraPbcore::Datastream::Instantiation.new(nil, 'test1')
    end

    it "creates dateable and displayable fields for complete dates" do
      @ds.date = "1898-11-12"
      expect(@ds.to_solr["test1__date_dtsim"]).to eq ["1898-11-12T00:00:00Z"]
      expect(@ds.to_solr["test1__date_ssm"]).to eq ["1898-11-12"]
    end

    it "creates only displayable fields for dates without day" do
      @ds.date = "1911-07"
      expect(@ds.to_solr["test1__date_dtsim"]).to eq []
      expect(@ds.to_solr["test1__date_ssm"]).to eq ["1911-07"]
    end

    it "creates only displayable fields for dates without day and month" do
      @ds.date = "1945"
      expect(@ds.to_solr["test1__date_dtsim"]).to eq []
      expect(@ds.to_solr["test1__date_ssm"]).to eq ["1945"]
    end

    it "creates only displayable for non-parseable dates" do
      @ds.date = "crap"
      expect(@ds.to_solr["test1__date_dtsim"]).to eq []
      expect(@ds.to_solr["test1__date_ssm"]).to eq ["crap"]
    end

  end 

end
