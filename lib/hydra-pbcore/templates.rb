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

end