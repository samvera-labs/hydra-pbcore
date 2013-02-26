module HydraPbcore::Datastream
class Instantiation < ActiveFedora::OmDatastream

  class_attribute :institution, :address
  self.institution = "Rock and Roll Hall of Fame and Museum"
  self.address     = "Rock and Roll Hall of Fame and Museum,\n2809 Woodland Ave.,\nCleveland, OH, 44115\n216-515-1956\nlibrary@rockhall.org"

  include HydraPbcore::Methods
  include HydraPbcore::Templates
  include HydraPbcore::Conversions

  # Note: this is not a complete PBCore document, just an instantiation node
  set_terminology do |t|
    t.root(:path=>"pbcoreInstantiation")

    t.name(
      :path => "instantiationIdentifier",
      :attributes=>{
        :annotation=>"Filename",
        :source=>self.institution
      },
      :index_as => [:displayable]
    )
    t.barcode(
      :path => "instantiationIdentifier",
      :attributes=>{
        :annotation=>"Barcode",
        :source=>self.institution
      },
      :index_as => [:displayable]
    )
    t.instantiationDate(:attributes=>{ :dateType=>"created" },
      :index_as => [:not_searchable, :converted_date, :displayable]
    )
    t.instantiationDigital(:attributes=>{ :source=>"EBU file formats" },
      :index_as => [:searchable, :facetable]
    )
    t.instantiationPhysical(:attributes=>{ :source=>"PBCore instantiationPhysical" },
      :index_as => [:searchable, :facetable]
    )
    t.instantiationStandard(:index_as => [:displayable])
    t.instantiationLocation(:index_as => [:displayable])
    t.instantiationGenerations(:attributes=>{ :source=>"PBCore instantiationGenerations" },
      :index_as => [:displayable]  
    )
    t.instantiationFileSize(:index_as => [:displayable]) do
      t.units(:path=>{:attribute=>"unitsOfMeasure"}, :index_as => [:displayable])
    end
    t.instantiationColors(:attributes=>{ :source=>"PBCore instantiationColors" },
      :index_as => [:displayable]
    )
    t.instantiationMediaType(:attributes=>{ :source=>"PBCore instantiationMediaType" },
      :index_as => [:facetable]
    )
    t.instantiationLanguage(
      :attributes=>{
        :source=>"ISO 639.2",
        :ref=>"http://www.loc.gov/standards/iso639-2/php/code_list.php"
      },
      :index_as => [:searchable]
    )
    t.instantiationDuration(:index_as => [:displayable])

    t.instantiationRights do
      t.rightsSummary(:index_as => [:displayable])
    end

    t.instantiationEssenceTrack do
      t.essenceTrackStandard(:index_as => [:displayable])
      t.essenceTrackEncoding( :attributes=>{ :source=>"PBCore essenceTrackEncoding" },
        :index_as => [:displayable]
      )
      t.essenceTrackDataRate(:index_as => [:displayable]) do
        t.units(:path=>{:attribute=>"unitsOfMeasure"}, :index_as => [:displayable])
      end
      t.essenceTrackFrameRate(:attributes=>{ :unitsOfMeasure=>"fps" }, :index_as => [:displayable])
      t.essenceTrackFrameSize(:attributes=>{ :source=>"PBCore essenceTrackFrameSize" }, :index_as => [:displayable])
      t.essenceTrackBitDepth(:index_as => [:displayable])
      t.essenceTrackAspectRatio(:attributes=>{ :source=>"PBCore essenceTrackAspectRatio" },
        :index_as => [:displayable]
      )
      t.essenceTrackSamplingRate(:index_as => [:displayable]) do
        t.units(:path=>{:attribute=>"unitsOfMeasure"}, :index_as => [:displayable])
      end
      t.essenceTrackAnnotation( :attributes=>{ :annotationType=>"Number of Audio Channels" },
        :index_as => [:displayable]
      )
    end
    t.video_essence(:ref => [:pbcoreInstantiation, :instantiationEssenceTrack],
      :path=>'instantiationEssenceTrack[essenceTrackType="Video"]'
    )
    t.audio_essence(:ref => [:pbcoreInstantiation, :instantiationEssenceTrack],
      :path=>'instantiationEssenceTrack[essenceTrackType="Audio"]'
    )

    t.instantiationRelation do
      t.instantiationRelationIdentifier(:attributes=>{ :source=>self.institution })
    end
    # The file we're describing at the root of this document preceeds the file marked "next"
    t.next_inst(:ref => [:pbcoreInstantiation, :instantiationRelation],
      :path=>'instantiationRelation[instantiationRelationType="Precedes in Sequence"]'
    )
    # The file we're describing at the root of this document comes after the file marked "previous"
    t.previous_inst(:ref => [:pbcoreInstantiation, :instantiationRelation],
      :path=>'instantiationRelation[instantiationRelationType="Follows in Sequence"]'
    )

    # Instantitation annotiations
    t.inst_chksum_type(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"Checksum Type" },
      :index_as => [:displayable]
    )
    t.inst_chksum_value(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"Checksum Value" },
      :index_as => [:displayable]
    )
    t.inst_device(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"Playback Device" },
      :index_as => [:displayable]
    )
    t.inst_capture_soft(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"Capture Software" },
      :index_as => [:displayable]
    )
    t.inst_trans_soft(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"Transcoding Software" },
      :index_as => [:displayable]
    )
    t.inst_operator(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"Operator" },
      :index_as => [:displayable]
    )
    t.inst_trans_note(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"Transfer Notes" },
      :index_as => [:displayable]
    )
    t.inst_vendor(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"Vendor Name" },
      :index_as => [:displayable]
    )
    t.inst_cond_note(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"Condition Notes" },
      :index_as => [:displayable]
    )
    t.inst_clean_note(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"Cleaning Notes" },
      :index_as => [:displayable]
    )
    t.inst_note(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"Notes" },
      :index_as => [:displayable]
    )
    t.inst_color_space(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"Color Space" },
      :index_as => [:displayable]
    )
    t.inst_chroma(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"Chroma" },
      :index_as => [:displayable]
    )

    t.condition_note(:path=>"instantiationAnnotation",
      :attributes=>{ :annotationType=>"Condition Notes"},
      :index_as => [:searchable, :displayable]
    )
    t.cleaning_note(:path=>"instantiationAnnotation", 
      :attributes=>{ :annotationType=>"Cleaning Notes" },
      :index_as => [:searchable, :displayable]
    )

    #
    # Proxied terms
    #
    t.location(:proxy=>[:instantiationLocation])
    t.date(:proxy=>[:instantiationDate])
    t.generation(:proxy=>[:instantiationGenerations])
    t.media_type(:proxy=>[:instantiationMediaType])
    t.file_format(:proxy=>[:instantiationDigital])
    t.format(:proxy=>[:instantiationPhysical])
    t.size(:proxy=>[:instantiationFileSize])
    t.size_units(:proxy=>[:instantiationFileSize, :units])
    t.colors(:proxy=>[:instantiationColors])
    t.duration(:proxy=>[:instantiationDuration])
    t.rights_summary(:proxy=>[:instantiationRights, :rightsSummary])

    # Proxies to annotation fields and other fields that are not in the template
    t.note(:proxy=>[:inst_note])
    t.checksum_type(:proxy=>[:inst_chksum_type])
    t.checksum_value(:proxy=>[:inst_chksum_value])
    t.device(:proxy=>[:inst_device])
    t.capture_soft(:proxy=>[:inst_capture_soft])
    t.trans_soft(:proxy=>[:inst_trans_soft])
    t.operator(:proxy=>[:inst_operator])
    t.trans_note(:proxy=>[:inst_trans_note])
    t.vendor(:proxy=>[:inst_vendor])
    t.condition(:proxy=>[:inst_cond_note])
    t.cleaning(:proxy=>[:inst_clean_note])
    t.color_space(:proxy=>[:inst_color_space])
    t.chroma(:proxy=>[:inst_chroma])
    t.standard(:proxy=>[:instantiationStandard])
    t.language(:proxy=>[:instantiationLanguage])

    # Proxies to video essence fields
    t.video_standard(:proxy=>[:video_essence, :essenceTrackStandard])
    t.video_encoding(:proxy=>[:video_essence, :essenceTrackEncoding])
    t.video_bit_rate(:proxy=>[:video_essence, :essenceTrackDataRate])
    t.video_bit_rate_units(:proxy=>[:video_essence, :essenceTrackDataRate, :units])
    t.frame_rate(:proxy=>[:video_essence, :essenceTrackFrameRate])
    t.frame_size(:proxy=>[:video_essence, :essenceTrackFrameSize])
    t.video_bit_depth(:proxy=>[:video_essence, :essenceTrackBitDepth])
    t.aspect_ratio(:proxy=>[:video_essence, :essenceTrackAspectRatio])

    # Proxies to audio essence fields
    t.audio_standard(:proxy=>[:audio_essence, :essenceTrackStandard])
    t.audio_encoding(:proxy=>[:audio_essence, :essenceTrackEncoding])
    t.audio_bit_rate(:proxy=>[:audio_essence, :essenceTrackDataRate])
    t.audio_bit_rate_units(:proxy=>[:audio_essence, :essenceTrackDataRate, :units])
    t.audio_sample_rate(:proxy=>[:audio_essence, :essenceTrackSamplingRate])
    t.audio_sample_rate_units(:proxy=>[:audio_essence, :essenceTrackSamplingRate, :units])
    t.audio_bit_depth(:proxy=>[:audio_essence, :essenceTrackBitDepth])
    t.audio_channels(:proxy=>[:audio_essence, :essenceTrackAnnotation])

    # Proxies to the relation fields
    t.next_(:proxy=>[:next_inst, :instantiationRelationIdentifier])
    t.previous_(:proxy=>[:previous_inst, :instantiationRelationIdentifier])
  end

  def define opts
    if opts == :physical 
      self.ng_xml = physical_instantiation
    elsif opts == :digital
      self.ng_xml = digital_instantiation
    else
      return self.ng_xml
    end
  end

end
end
