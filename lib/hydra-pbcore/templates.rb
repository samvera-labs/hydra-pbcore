module HydraPbcore::Templates
  extend ActiveSupport::Concern

  included do
    class_eval do

      define_template :publisher do |xml|
        xml.pbcorePublisher {
          xml.publisher
          xml.publisherRole(:source=>"PBCore publisherRole")
        }
      end

      define_template :contributor do |xml|
        xml.pbcoreContributor {
          xml.contributor
          xml.contributorRole(:source=>"MARC relator terms")
        }
      end

      define_template :previous do |xml|
        xml.instantiationRelation {
          xml.instantiationRelationType(:annotation=>"One of a multi-part instantiation") {
            xml.text "Follows in Sequence"
          }
          xml.instantiationRelationIdentifier(:source=>"Rock and Roll Hall of Fame and Museum")
        }
      end

      define_template :next do |xml|
        xml.instantiationRelation {
          xml.instantiationRelationType(:annotation=>"One of a multi-part instantiation") {
            xml.text "Precedes in Sequence"
          }
          xml.instantiationRelationIdentifier(:source=>"Rock and Roll Hall of Fame and Museum")
        }
      end

    end
  end

  def insert_contributor
    add_child_node(ng_xml.root, :contributor)
  end

  def insert_publisher
    add_child_node(ng_xml.root, :publisher)
  end

end