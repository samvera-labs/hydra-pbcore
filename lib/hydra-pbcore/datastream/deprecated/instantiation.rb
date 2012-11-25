module HydraPbcore::Datastream::Deprecated
class Instantiation < ActiveFedora::NokogiriDatastream

  include HydraPbcore::Methods
  include HydraPbcore::Templates

  # Note: this is not a complete PBCore document, just an instantiation node
  set_terminology do |t|
    t.root(:path=>"pbcoreDescriptionDocument")

    t.pbcoreInstantiation do

      t.instantiationIdentifier(
        :attributes=>{
          :annotation=>"Filename",
          :source=>"Rock and Roll Hall of Fame and Museum"
        },
        :index_as => [:displayable]
      )
      t.instantiationDate(:attributes=>{ :dateType=>"created" },
        :index_as => [:not_searchable, :converted_date, :displayable]
      )
      t.instantiationDigital(:attributes=>{ :source=>"EBU file formats" },
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
        t.instantiationRelationIdentifier(:attributes=>{ :source=>"Rock and Roll Hall of Fame and Museum" })
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

    end

    #
    # Here are the actual references to the fields
    #
    t.name(:proxy=>[:pbcoreInstantiation, :instantiationIdentifier])
    t.location(:proxy=>[:pbcoreInstantiation, :instantiationLocation])
    t.date(:proxy=>[:pbcoreInstantiation, :instantiationDate])
    t.generation(:proxy=>[:pbcoreInstantiation, :instantiationGenerations])
    t.media_type(:proxy=>[:pbcoreInstantiation, :instantiationMediaType])
    t.file_format(:proxy=>[:pbcoreInstantiation, :instantiationDigital])
    t.size(:proxy=>[:pbcoreInstantiation, :instantiationFileSize])
    t.size_units(:proxy=>[:pbcoreInstantiation, :instantiationFileSize, :units])
    t.colors(:proxy=>[:pbcoreInstantiation, :instantiationColors])
    t.duration(:proxy=>[:pbcoreInstantiation, :instantiationDuration])
    t.rights_summary(:proxy=>[:pbcoreInstantiation, :instantiationRights, :rightsSummary])

    # Proxies to annotation fields and other fields that are not in the template
    t.note(:proxy=>[:pbcoreInstantiation, :inst_note])
    t.checksum_type(:proxy=>[:pbcoreInstantiation, :inst_chksum_type])
    t.checksum_value(:proxy=>[:pbcoreInstantiation, :inst_chksum_value])
    t.device(:proxy=>[:pbcoreInstantiation, :inst_device])
    t.capture_soft(:proxy=>[:pbcoreInstantiation, :inst_capture_soft])
    t.trans_soft(:proxy=>[:pbcoreInstantiation, :inst_trans_soft])
    t.operator(:proxy=>[:pbcoreInstantiation, :inst_operator])
    t.trans_note(:proxy=>[:pbcoreInstantiation, :inst_trans_note])
    t.vendor(:proxy=>[:pbcoreInstantiation, :inst_vendor])
    t.condition(:proxy=>[:pbcoreInstantiation, :inst_cond_note])
    t.cleaning(:proxy=>[:pbcoreInstantiation, :inst_clean_note])
    t.color_space(:proxy=>[:pbcoreInstantiation, :inst_color_space])
    t.chroma(:proxy=>[:pbcoreInstantiation, :inst_chroma])
    t.standard(:proxy=>[:pbcoreInstantiation, :instantiationStandard])
    t.language(:proxy=>[:pbcoreInstantiation, :instantiationLanguage])

    # Proxies to video essence fields
    t.video_standard(:proxy=>[:pbcoreInstantiation, :video_essence, :essenceTrackStandard])
    t.video_encoding(:proxy=>[:pbcoreInstantiation, :video_essence, :essenceTrackEncoding])
    t.video_bit_rate(:proxy=>[:pbcoreInstantiation, :video_essence, :essenceTrackDataRate])
    t.video_bit_rate_units(:proxy=>[:pbcoreInstantiation, :video_essence, :essenceTrackDataRate, :units])
    t.frame_rate(:proxy=>[:pbcoreInstantiation, :video_essence, :essenceTrackFrameRate])
    t.frame_size(:proxy=>[:pbcoreInstantiation, :video_essence, :essenceTrackFrameSize])
    t.video_bit_depth(:proxy=>[:pbcoreInstantiation, :video_essence, :essenceTrackBitDepth])
    t.aspect_ratio(:proxy=>[:pbcoreInstantiation, :video_essence, :essenceTrackAspectRatio])

    # Proxies to audio essence fields
    t.audio_standard(:proxy=>[:pbcoreInstantiation, :audio_essence, :essenceTrackStandard])
    t.audio_encoding(:proxy=>[:pbcoreInstantiation, :audio_essence, :essenceTrackEncoding])
    t.audio_bit_rate(:proxy=>[:pbcoreInstantiation, :audio_essence, :essenceTrackDataRate])
    t.audio_bit_rate_units(:proxy=>[:pbcoreInstantiation, :audio_essence, :essenceTrackDataRate, :units])
    t.audio_sample_rate(:proxy=>[:pbcoreInstantiation, :audio_essence, :essenceTrackSamplingRate])
    t.audio_sample_rate_units(:proxy=>[:pbcoreInstantiation, :audio_essence, :essenceTrackSamplingRate, :units])
    t.audio_bit_depth(:proxy=>[:pbcoreInstantiation, :audio_essence, :essenceTrackBitDepth])
    t.audio_channels(:proxy=>[:pbcoreInstantiation, :audio_essence, :essenceTrackAnnotation])

    # Proxies to the relation fields
    t.next_(:proxy=>[:pbcoreInstantiation, :next_inst, :instantiationRelationIdentifier])
    t.previous_(:proxy=>[:pbcoreInstantiation, :previous_inst, :instantiationRelationIdentifier])

  end

  def self.xml_template
    builder = Nokogiri::XML::Builder.new do |xml|

      xml.pbcoreDescriptionDocument("xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
        "xsi:schemaLocation"=>"http://www.pbcore.org/PBCore/PBCoreNamespace.html") {

        # These fields are only added so that this document will be validated.  However, they
        # shouldn't be used for anything else here because they're in the parent Fedora object
        xml.pbcoreIdentifier(:annotation=>"PID", :source=>"Rock and Roll Hall of Fame and Museum")
        xml.pbcoreTitle
        xml.pbcoreDescription

        xml.pbcoreInstantiation {

          xml.instantiationIdentifier(:annotation=>"Filename", :source=>"Rock and Roll Hall of Fame and Museum")
          xml.instantiationDate(:dateType=>"created")
          xml.instantiationDigital(:source=>"EBU file formats")
          xml.instantiationLocation
          xml.instantiationMediaType(:source=>"PBCore instantiationMediaType") {
            xml.text "Moving image"
          }
          xml.instantiationGenerations(:source=>"PBCore instantiationGenerations")
          xml.instantiationFileSize(:unitsOfMeasure=>"")
          xml.instantiationDuration
          xml.instantiationColors(:source=>"PBCore instantiationColors") {
            xml.text "Color"
          }

          xml.instantiationEssenceTrack {
            xml.essenceTrackType {
              xml.text "Video"
            }
            xml.essenceTrackStandard
            xml.essenceTrackEncoding(:source=>"PBCore essenceTrackEncoding")
            xml.essenceTrackDataRate(:unitsOfMeasure=>"")
            xml.essenceTrackFrameRate(:unitsOfMeasure=>"fps")
            xml.essenceTrackBitDepth
            xml.essenceTrackFrameSize(:source=>"PBCore essenceTrackFrameSize")
            xml.essenceTrackAspectRatio(:source=>"PBCore essenceTrackAspectRatio")
          }

          xml.instantiationEssenceTrack {
            xml.essenceTrackType {
              xml.text "Audio"
            }
            xml.essenceTrackStandard
            xml.essenceTrackEncoding(:source=>"PBCore essenceTrackEncoding")
            xml.essenceTrackDataRate(:unitsOfMeasure=>"")
            xml.essenceTrackSamplingRate(:unitsOfMeasure=>"")
            xml.essenceTrackBitDepth
            xml.essenceTrackAnnotation(:annotationType=>"Number of Audio Channels")
          }

          xml.instantiationRights {
            xml.rightsSummary
          }

        }

      }

    end
    return builder.doc
  end

end
end
