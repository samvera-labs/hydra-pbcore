module HydraPbcore::Datastream
class Document < ActiveFedora::NokogiriDatastream

  include HydraPbcore::Methods
  include HydraPbcore::Templates

  set_terminology do |t|
    t.root(:path=>"pbcoreDescriptionDocument")

    t.pbc_id(:path=>"pbcoreIdentifier", 
      :attributes=>{ :source=>"Rock and Roll Hall of Fame and Museum", :annotation=>"PID" }
    )

    t.main_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Main" }, :index_as => [:searchable, :displayable])
    t.alternative_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Alternative" },
      :index_as => [:searchable, :displayable]
    )
    t.chapter(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Chapter" }, :index_as => [:searchable, :displayable])
    t.episode(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Episode" }, :index_as => [:searchable, :displayable])
    t.label(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Label" }, :index_as => [:searchable, :displayable])
    t.segment(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Segment" }, :index_as => [:searchable, :displayable])
    t.subtitle(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Subtitle" }, :index_as => [:searchable, :displayable])
    t.track(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Track" }, :index_as => [:searchable, :displayable])
    t.translation(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Translation" }, 
      :index_as => [:searchable, :displayable]
    )

    # This is only to display all subjects
    t.subject_topic(:path=>"pbcoreSubject", :index_as => [:searchable, :facetable])

    # Individual subject types defined for entry
    t.lc_subject(:path=>"pbcoreSubject", 
      :attributes=>{ 
        :source=>"Library of Congress Subject Headings", 
        :ref=>"http://id.loc.gov/authorities/subjects.html"
      },
      :index_as => [:displayable]
    )
    t.lc_name(:path=>"pbcoreSubject",
      :attributes=>{ :source=>"Library of Congress Name Authority File", :ref=>"http://id.loc.gov/authorities/names" },
      :index_as => [:displayable]
    )
    t.rh_subject(:path=>"pbcoreSubject", 
      :attributes=>{ :source=>"Rock and Roll Hall of Fame and Museum" },
      :index_as => [:displayable]
    )

    t.summary(:path=>"pbcoreDescription", 
      :attributes=>{ 
        :descriptionType=>"Description",
        :descriptionTypeSource=>"pbcoreDescription/descriptionType",
        :descriptionTypeRef=>"http://pbcore.org/vocabularies/pbcoreDescription/descriptionType#description",
        :annotation=>"Summary"
        },
        :index_as => [:searchable, :displayable]
    )

    t.parts_list(:path=>"pbcoreDescription", 
      :attributes=>{ 
        :descriptionType=>"Table of Contents",
        :descriptionTypeSource=>"pbcoreDescription/descriptionType",
        :descriptionTypeRef=>"http://pbcore.org/vocabularies/pbcoreDescription/descriptionType#table-of-contents",
        :annotation=>"Parts List"
      },
      :index_as => [:searchable, :displayable]
    )

    # This is only to display all genres
    t.genres(:path=>"pbcoreGenre", :index_as => [:searchable, :facetable])

    # Individual genre types defined for entry
    t.getty_genre(:path=>"pbcoreGenre", 
      :attributes=>{ 
        :source=>"The Getty Research Institute Art and Architecture Thesaurus",
        :ref=>"http://www.getty.edu/research/tools/vocabularies/aat/index.html"
      },
      :index_as => [:displayable] 
    )
    t.lc_genre(:path=>"pbcoreGenre",
      :attributes=>{
        :source=>"Library of Congress Genre/Form Terms", 
        :ref=>"http://id.loc.gov/authorities/genreForms.html"
      },
      :index_as => [:displayable]
    )
    t.lc_subject_genre(:path=>"pbcoreGenre",
      :attributes=>{
        :source=>"Library of Congress Subject Headings",
        :ref=>"http://id.loc.gov/authorities/subjects.html"
      },
      :index_as => [:displayable]    
    )

    # PBCore relation fields
    t.pbcoreRelation do
      t.series(:path=>"pbcoreRelationIdentifier", :attributes=>{ :annotation=>"Event Series" })
      t.arch_coll(:path=>"pbcoreRelationIdentifier", :attributes=>{ :annotation=>"Archival Collection" })
      t.arch_ser(:path=>"pbcoreRelationIdentifier", :attributes=>{ :annotation=>"Archival Series" })
      t.coll_num(:path=>"pbcoreRelationIdentifier", :attributes=>{ :annotation=>"Collection Number" })
      t.acc_num(:path=>"pbcoreRelationIdentifier", :attributes=>{ :annotation=>"Accession Number" })
    end
    t.event_series(:ref=>[:pbcoreRelation, :series], :index_as => [:searchable, :displayable])
    t.archival_collection(:ref=>[:pbcoreRelation, :arch_coll], :index_as => [:searchable, :displayable])
    t.archival_series(:ref=>[:pbcoreRelation, :arch_ser], :index_as => [:searchable, :displayable])
    t.collection_number(:ref=>[:pbcoreRelation, :coll_num], :index_as => [:searchable, :displayable])
    t.accession_number(:ref=>[:pbcoreRelation, :acc_num], :index_as => [:searchable, :displayable])

    t.pbcoreCoverage
    # Terms for time and place
    t.event_place(:path=>"pbcoreCoverage/coverage", 
      :attributes => {:annotation=>"Event Place"},
      :index_as => [:searchable, :displayable]
    )
    t.event_date(:path=>"pbcoreCoverage/coverage", 
      :attributes => {:annotation=>"Event Date"},
      :index_as => [:not_searchable, :converted_date, :displayable]
    )

    # Contributor names and roles
    t.contributor(:path=>"pbcoreContributor") do
      t.name_(:path=>"contributor", :index_as => [:searchable, :facetable])
      t.role_(:path=>"contributorRole", 
        :attributes=>{ :source=>"MARC relator terms" },
        :index_as => [:searchable, :displayable]
      )
    end
    t.contributor_name(:proxy=>[:contributor, :name])
    t.contributor_role(:proxy=>[:contributor, :role])

    # Publisher names and roles
    t.publisher(:path=>"pbcorePublisher") do
      t.name_(:path=>"publisher")
      t.role_(:path=>"publisherRole", :attributes=>{ :source=>"PBCore publisherRole" })
    end
    t.publisher_name(:proxy=>[:publisher, :name], :index_as => [:searchable, :facetable])
    t.publisher_role(:proxy=>[:publisher, :role], :index_as => [:searchable, :displayable])

    t.note(:path=>"pbcoreAnnotation", :atttributes=>{ :annotationType=>"Notes" }, :index_as => [:searchable])

    t.pbcoreRightsSummary do
      t.rightsSummary
    end
    t.rights_summary(:ref => [:pbcoreRightsSummary, :rightsSummary], :index_as => [:searchable, :displayable])

  end

  def self.xml_template
    builder = Nokogiri::XML::Builder.new do |xml|

      xml.pbcoreDescriptionDocument("xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
        "xsi:schemaLocation"=>"http://www.pbcore.org/PBCore/PBCoreNamespace.html") {

        xml.pbcoreIdentifier(:source=>"Rock and Roll Hall of Fame and Museum", :annotation=>"PID")
        xml.pbcoreTitle(:titleType=>"Main")
        xml.pbcoreDescription(:descriptionType=>"Description",
          :descriptionTypeSource=>"pbcoreDescription/descriptionType",
          :descriptionTypeRef=>"http://pbcore.org/vocabularies/pbcoreDescription/descriptionType#description",
          :annotation=>"Summary"
        )
        xml.pbcoreDescription(:descriptionType=>"Table of Contents",
          :descriptionTypeSource=>"pbcoreDescription/descriptionType",
          :descriptionTypeRef=>"http://pbcore.org/vocabularies/pbcoreDescription/descriptionType#table-of-contents",
          :annotation=>"Parts List"
        )
        xml.pbcoreRelation {
          xml.pbcoreRelationType(:source=>"PBCore relationType", :ref=>"http://pbcore.org/vocabularies/relationType#is-part-of") {
            xml.text "Is Part Of"
          }
          xml.pbcoreRelationIdentifier(:annotation=>"Event Series")
        }
        xml.pbcoreRelation {
          xml.pbcoreRelationType(:source=>"PBCore relationType", :ref=>"http://pbcore.org/vocabularies/relationType#is-part-of") {
            xml.text "Is Part Of"
          }
          xml.pbcoreRelationIdentifier(:annotation=>"Archival Collection")
        }
        xml.pbcoreRelation {
          xml.pbcoreRelationType(:source=>"PBCore relationType", :ref=>"http://pbcore.org/vocabularies/relationType#is-part-of") {
            xml.text "Is Part Of"
          }
          xml.pbcoreRelationIdentifier(:annotation=>"Archival Series")
        }
        xml.pbcoreRelation {
          xml.pbcoreRelationType(:source=>"PBCore relationType", :ref=>"http://pbcore.org/vocabularies/relationType#is-part-of") {
            xml.text "Is Part Of"
          }
          xml.pbcoreRelationIdentifier(:annotation=>"Collection Number")
        }
        xml.pbcoreRelation {
          xml.pbcoreRelationType(:source=>"PBCore relationType", :ref=>"http://pbcore.org/vocabularies/relationType#is-part-of") {
            xml.text "Is Part Of"
          }
          xml.pbcoreRelationIdentifier(:annotation=>"Accession Number")
        }
        xml.pbcoreCoverage {
          xml.coverage(:annotation=>"Event Place")
          xml.coverageType {
            xml.text "Spatial"
          }
        }
        xml.pbcoreCoverage {
          xml.coverage(:annotation=>"Event Date")
          xml.coverageType {
            xml.text "Temporal"
          }
        }
        xml.pbcoreRightsSummary {
          xml.rightsSummary
        }
        xml.pbcoreAnnotation(:annotationType=>"Notes")

      }

    end
    return builder.doc
  end

end
end