module HydraPbcore::Datastream
class Document < ActiveFedora::NokogiriDatastream

  include HydraPbcore::Methods

  set_terminology do |t|
    t.root(:path=>"pbcoreDescriptionDocument")

    #
    #  pbcoreDescription fields
    #
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


    # Series field
    t.pbcoreRelation do
      t.pbcoreRelationIdentifier(:attributes=>{ :annotation=>"Event Series" })
    end
    t.event_series(:ref=>[:pbcoreRelation, :pbcoreRelationIdentifier], :index_as => [:searchable, :displayable])

    # Terms for time and place
    t.event_place(:path=>"pbcoreCoverage/coverage", 
      :attributes => {:annotation=>"Event Place"},
      :index_as => [:searchable, :displayable]
    )
    t.event_date(:path=>"pbcoreCoverage/coverage", 
      :attributes => {:annotation=>"Event Date"},
      :index_as => [:searchable, :displayable]
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

    t.note(:path=>"pbcoreAnnotation", :atttributes=>{ :annotationType=>"Notes" })

    #
    # pbcoreInstantiation fields for the physical item
    #
    t.pbcoreInstantiation do
      t.instantiationIdentifier(:attributes=>{ 
        :annotation=>"Barcode", 
        :source=>"Rock and Roll Hall of Fame and Museum"
      })
      t.instantiationDate(:attributes=>{ :dateType=>"created" })
      t.instantiationPhysical(:attributes=>{ :source=>"PBCore instantiationPhysical" })
      t.instantiationStandard
      t.instantiationLocation
      t.instantiationMediaType(:attributes=>{ :source=>"PBCore instantiationMediaType" })
      t.instantiationGenerations(:attributes=>{ :source=>"PBCore instantiationGenerations" })
      t.instantiationColors
      t.instantiationLanguage(:attributes=>{ 
        :source=>"ISO 639.2", 
        :ref=>"http://www.loc.gov/standards/iso639-2/php/code_list.php"
      })
      t.instantiationRelation do
        t.arc_collection(:path=>"instantiationRelationIdentifier", 
          :attributes=>{ :annotation=>"Archival collection" },
          :index_as => [:searchable, :facetable]
        )
        t.arc_series(:path=>"instantiationRelationIdentifier", :attributes=>{ :annotation=>"Archival Series" })
        t.col_number(:path=>"instantiationRelationIdentifier", :attributes=>{ :annotation=>"Collection Number" })
        t.acc_number(:path=>"instantiationRelationIdentifier", :attributes=>{ :annotation=>"Accession Number" })
      end
      t.instantiationRights do
        t.rightsSummary
      end
      t.inst_cond_note(:path=>"instantiationAnnotation",
        :attributes=>{ :annotationType=>"Condition Notes"},
        :index_as => [:searchable, :displayable]
      )
      t.inst_clean_note(:path=>"instantiationAnnotation", 
        :attributes=>{ :annotationType=>"Cleaning Notes" },
        :index_as => [:searchable, :displayable]
      )
    end
    # Individual field names:
    t.creation_date(:ref=>[:pbcoreInstantiation, :instantiationDate], :index_as => [:searchable, :displayable])
    t.barcode(:ref=>[:pbcoreInstantiation, :instantiationIdentifier], :index_as => [:searchable, :displayable])
    t.repository(:ref=>[:pbcoreInstantiation, :instantiationLocation], :index_as => [:searchable, :displayable])
    t.format(:ref=>[:pbcoreInstantiation, :instantiationPhysical], :index_as => [:searchable, :facetable])
    t.standard(:ref=>[:pbcoreInstantiation, :instantiationStandard], :index_as => [:searchable, :facetable])
    t.media_type(:ref=>[:pbcoreInstantiation, :instantiationMediaType], :index_as => [:searchable, :facetable])
    t.generation(:ref=>[:pbcoreInstantiation, :instantiationGenerations], :index_as => [:searchable, :displayable])
    t.language(:ref=>[:pbcoreInstantiation, :instantiationLanguage], :index_as => [:searchable, :displayable])
    t.colors(:ref=>[:pbcoreInstantiation, :instantiationColors], :index_as => [:searchable, :displayable])
    t.archival_collection(
      :ref=>[:pbcoreInstantiation, :instantiationRelation, :arc_collection], 
      :index_as => [:searchable, :facetable]
    )
    t.archival_series(
      :ref=>[:pbcoreInstantiation, :instantiationRelation, :arc_series], 
      :index_as => [:searchable, :displayable]
    )
    t.collection_number(
      :ref=>[:pbcoreInstantiation, :instantiationRelation, :col_number], 
      :index_as => [:searchable, :displayable]
    )
    t.accession_number(:ref=>[:pbcoreInstantiation, :instantiationRelation, :acc_number],
      :index_as => [:searchable, :displayable]
    )
    t.usage(:ref=>[:pbcoreInstantiation, :instantiationRights, :rightsSummary],
      :index_as => [:searchable, :displayable]
    )
    
    # Inserted terms
    t.condition_note(:proxy=>[:pbcoreInstantiation, :inst_cond_note])
    t.cleaning_note(:proxy=>[:pbcoreInstantiation, :inst_clean_note])
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
        xml.pbcoreAnnotation(:annotationType=>"Notes")

        #
        # Default physical item
        #
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
          xml.instantiationColors {
            xml.text "Color"
          }
          xml.instantiationLanguage(:source=>"ISO 639.2", :ref=>"http://www.loc.gov/standards/iso639-2/php/code_list.php") {
            xml.text "eng"
          }
          xml.instantiationRelation {
            xml.instantiationRelationType(:source=>"PBCore relationType", :ref=>"http://pbcore.org/vocabularies/relationType#is-part-of") {
              xml.text "Is Part Of"
            }
            xml.instantiationRelationIdentifier(:annotation=>"Archival Collection")
          }
          xml.instantiationRelation {
            xml.instantiationRelationType(:source=>"PBCore relationType", :ref=>"http://pbcore.org/vocabularies/relationType#is-part-of") {
              xml.text "Is Part Of"
            }
            xml.instantiationRelationIdentifier(:annotation=>"Archival Series")
          }
          xml.instantiationRelation {
            xml.instantiationRelationType(:source=>"PBCore relationType", :ref=>"http://pbcore.org/vocabularies/relationType#is-part-of") {
              xml.text "Is Part Of"
            }
            xml.instantiationRelationIdentifier(:annotation=>"Collection Number")
          }
          xml.instantiationRelation {
            xml.instantiationRelationType(:source=>"PBCore relationType", :ref=>"http://pbcore.org/vocabularies/relationType#is-part-of") {
              xml.text "Is Part Of"
            }
            xml.instantiationRelationIdentifier(:annotation=>"Accession Number")
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