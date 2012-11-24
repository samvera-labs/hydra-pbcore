module HydraPbcore::Templates
  extend ActiveSupport::Concern

  included do
    class_eval do

      define_template :publisher do |xml, publisher, role|
        xml.pbcorePublisher {
          xml.publisher(publisher)
          xml.publisherRole(role, :source=>"PBCore publisherRole")
        }
      end

      define_template :contributor do |xml, author, role|
        xml.pbcoreContributor {
          xml.contributor(author)
          xml.contributorRole(role, :source=>"MARC relator terms") 
        }
      end

      define_template :previous do |xml, file|
        xml.instantiationRelation {
          xml.instantiationRelationType(:annotation=>"One of a multi-part instantiation") {
            xml.text "Follows in Sequence"
          }
          xml.instantiationRelationIdentifier(file, :source=>"Rock and Roll Hall of Fame and Museum")
        }
      end

      define_template :next do |xml, file|
        xml.instantiationRelation {
          xml.instantiationRelationType(:annotation=>"One of a multi-part instantiation") {
            xml.text "Precedes in Sequence"
          }
          xml.instantiationRelationIdentifier(file, :source=>"Rock and Roll Hall of Fame and Museum")
        }
      end

    end
  end

  def insert_contributor(author=nil, role=nil)
    add_child_node(ng_xml.root, :contributor, author, role)
  end

  def insert_publisher(publisher=nil, role=nil)
    add_child_node(ng_xml.root, :publisher, publisher, role)
  end

  def insert_next(file)
    add_child_node(find_by_terms(:pbcoreInstantiation).first, :next, file)
  end

  def insert_previous(file)
    add_child_node(find_by_terms(:pbcoreInstantiation).first, :previous, file)
  end

  def digital_instantiation
    builder = Nokogiri::XML::Builder.new do |xml|

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

    end
    return builder.doc
  end

  def physical_instantiation
    builder = Nokogiri::XML::Builder.new do |xml|
      
      xml.pbcoreInstantiation {

        # Item details
        xml.instantiationIdentifier(:annotation=>"Barcode", :source=>"Rock and Roll Hall of Fame and Museum")
        xml.instantiationDate(:dateType=>"created")
        xml.instantiationPhysical(:source=>"PBCore instantiationPhysical")
        xml.instantiationStandard
        xml.instantiationLocation {
          xml.text "Rock and Roll Hall of Fame and Museum,\n2809 Woodland Ave.,\nCleveland, OH, 44115\n216-515-1956\nlibrary@rockhall.org"
        }
        xml.instantiationMediaType(:source=>"PBCore instantiationMediaType") {
          xml.text "Moving image"
        }
        xml.instantiationGenerations(:source=>"PBCore instantiationGenerations") {
          xml.text "Original"
        }
        xml.instantiationColors(:source=>"PBCore instantiationColors") {
          xml.text "Color"
        }
        xml.instantiationLanguage(:source=>"ISO 639.2", :ref=>"http://www.loc.gov/standards/iso639-2/php/code_list.php") {
          xml.text "eng"
        }
        xml.instantiationRights {
          xml.rightsSummary
        }

      }
    
    end
    return builder.doc
  end


end