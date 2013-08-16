module HydraPbcore::Templates
  extend ActiveSupport::Concern

  included do
    class_eval do

      define_template :creator do |xml, author, role|
        xml.pbcoreCreator {
          xml.creator(author)
          xml.creatorRole(role, :source=>"PBCore creatorRole") 
        }
      end

      define_template :publisher do |xml, publisher, role|
        xml.pbcorePublisher {
          xml.publisher(publisher)
          xml.publisherRole(role, :source=>"PBCore publisherRole")
        }
      end

      define_template :contributor do |xml, author, role|
        xml.pbcoreContributor {
          xml.contributor(author)
          xml.contributorRole(role, :source=>HydraPbcore.config["relator"]) 
        }
      end

      define_template :previous do |xml, file|
        xml.instantiationRelation {
          xml.instantiationRelationType(:annotation=>"One of a multi-part instantiation") {
            xml.text "Follows in Sequence"
          }
          xml.instantiationRelationIdentifier(file, :source=>HydraPbcore.config["institution"])
        }
      end

      define_template :next do |xml, file|
        xml.instantiationRelation {
          xml.instantiationRelationType(:annotation=>"One of a multi-part instantiation") {
            xml.text "Precedes in Sequence"
          }
          xml.instantiationRelationIdentifier(file, :source=>HydraPbcore.config["institution"])
        }
      end

      define_template :event_place do |xml, location, type="Event Place"|
        xml.pbcoreCoverage {
          xml.coverage(location, :annotation=>type)
          xml.coverageType {
            xml.text "Spatial"
          }
        }
      end

      define_template :event_date do |xml, date, type="Event Date"|
        xml.pbcoreCoverage {
          xml.coverage(date, :annotation=>type)
          xml.coverageType {
            xml.text "Temporal"
          }
        }
      end

      define_template :relation do |xml, value, annotation, type="Is Part Of"|
        xml.pbcoreRelation {
          xml.pbcoreRelationType(type, :source=>"PBCore relationType", :ref=>"http://pbcore.org/vocabularies/relationType#is-part-of")
          xml.pbcoreRelationIdentifier(value, :annotation=>annotation)
        }
      end

      define_template :identifier do |xml, identifier, source, annotation|
        attributes = {source: source}
        attributes[:annotation] = annotation if annotation
        xml.pbcoreIdentifier(identifier, attributes)
      end
    end
  end

  def insert_creator(author=nil, role=nil)
    add_child_node(ng_xml.root, :creator, author, role)
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

  # Create a pbcoreCoverage node with related subnodes for a place.
  # @param location the location to insert into the coverage node
  # @param type (optional) the annotation for the coverage node
  def insert_place(location, *type)
    add_child_node(ng_xml.root, :event_place, location, *type)
  end

  # Create a pbcoreCoverage node with related subnodes for a date.
  # @param date the date to insert into the coverage node
  # @param type (optional) the annotation for the coverage node
  def insert_date(date, *type)
    add_child_node(ng_xml.root, :event_date, date, *type)
  end

  def insert_relation(value, annotation)
    add_child_node(ng_xml.root, :relation, value, annotation)
  end

  def insert_identifier(identifier, annotation=nil, source=HydraPbcore.config["institution"])
    add_child_node(ng_xml.root, :identifier, identifier, source, annotation)
  end

  def digital_instantiation
    builder = Nokogiri::XML::Builder.new do |xml|

      xml.pbcoreInstantiation {

        xml.instantiationIdentifier(:annotation=>"Filename", :source=>HydraPbcore.config["institution"])
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
        xml.instantiationIdentifier(:annotation=>"Barcode", :source=>HydraPbcore.config["institution"])
        xml.instantiationDate(:dateType=>"created")
        xml.instantiationPhysical(:source=>"PBCore instantiationPhysical")
        xml.instantiationStandard
        xml.instantiationLocation {
          xml.text HydraPbcore.config["address"]
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
