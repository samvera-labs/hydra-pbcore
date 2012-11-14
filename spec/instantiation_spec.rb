require "spec_helper"

describe HydraPbcore::Datastream::Instantiation do

  before(:each) do
    @object_ds = HydraPbcore::Datastream::Instantiation.new(nil, nil)
  end

  describe ".update_indexed_attributes" do
    it "should update all of the fields in #xml_template and fields not requiring additional inserted nodes" do
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
        test_val = "#{pointer.last.to_s} value"
        @object_ds.update_indexed_attributes( {pointer=>{"0"=>test_val}} )
        @object_ds.get_values(pointer).first.should == test_val
        @object_ds.get_values(pointer).length.should == 1
      end
    end
  end

  describe "default fields" do

    it "like media type should be 'Moving image'" do
      @object_ds.get_values([:media_type]).first.should == "Moving image"
    end

    it "like colors should be 'Color'" do
      @object_ds.get_values([:colors]).first.should == "Color"
    end

  end

  describe "#xml_template" do
    it "should return an empty xml document matching an exmplar" do

      # insert optional fields
      @object_ds.update_indexed_attributes({ [:checksum_type] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:note] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:checksum_value] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:device] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:capture_soft] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:trans_soft] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:operator] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:trans_note] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:vendor] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:condition] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:cleaning] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:color_space] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:chroma] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:standard] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:language] => { 0 => "inserted" }} )

      # insert optional nodes using sample values
      @object_ds.insert_next("inserted")
      @object_ds.insert_previous("inserted")

      # Load example fixture
      f = fixture "pbcore_instantiation_template.xml"
      ref_node = Nokogiri::XML(f)
      f.close

      # Nokogiri-fy our sample document and add in namespace
      sample_node = Nokogiri::XML(@object_ds.to_xml)
      with_namespace = HydraPbcore::Behaviors.insert_pbcore_namespace(sample_node)

      # Save this for later...
      out = File.new("tmp/pbcore_instantiation_sample.xml", "w")
      out.write(with_namespace.to_s)
      out.close

      EquivalentXml.equivalent?(ref_node, with_namespace, opts = { :element_order => false, :normalize_whitespace => true }).should be_true

      # TODO: reorder nodes on the instantiaion
      #Rockhall::Pbcore.validate(with_namespace).should be_empty
    end
  end

  describe "essence fields" do

    it "shoud have different essenceTrackStandard nodes" do

      # Standard
      @object_ds.update_indexed_attributes({ [:video_standard] => { 0 => "video standard" }} )
      @object_ds.update_indexed_attributes({ [:audio_standard] => { 0 => "audio standard" }} )
      @object_ds.get_values([{:pbcoreInstantiation=>0}, {:instantiationEssenceTrack=>0}, :essenceTrackStandard]).first.should == "video standard"
      @object_ds.get_values([{:pbcoreInstantiation=>0}, {:instantiationEssenceTrack=>1}, :essenceTrackStandard]).first.should == "audio standard"

    end

  end

  describe ".to_solr" do

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
        @object_ds.send("#{field}=".to_sym, field)
      end

      # Use a real date
       @object_ds.date = "2012-11"
    end

    it "should match an exmplar" do
      # Load example fixture
      f = fixture "pbcore_solr_instantiation_template.xml"
      ref_node = Nokogiri::XML(f)
      f.close

      # Nokogiri-fy our sample document
      sample_node = Nokogiri::XML(@object_ds.to_solr.to_xml)

      # Save this for later...
      out = File.new("tmp/pbcore_solr_instantation_sample.xml", "w")
      out.write(sample_node.to_s)
      out.close

      EquivalentXml.equivalent?(ref_node, sample_node, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end

    it "should display dates as they were entered" do
      @object_ds.to_solr["date_display"].should == ["2012-11"]
    end

    it "should have dates converted to ISO 8601" do
      @object_ds.to_solr["date_dt"].should == ["2012-11-01T00:00:00Z"]
    end

    it "should not index dates as text" do
      @object_ds.to_solr["date_t"].should be_nil
    end

  end

end
