module HydraPbcore::Datastream
class Document < ActiveFedora::OmDatastream

  include HydraPbcore::Methods
  include HydraPbcore::Templates

  set_terminology do |t|
    t.root(:path=>"pbcoreDescriptionDocument")

    t.pbc_id(:path=>"pbcoreIdentifier", :attributes=>{ :source=>HydraPbcore.config["institution"] })

    t.title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Main" }, :index_as => [:searchable, :displayable, :sortable])
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
    t.subject(:path=>"pbcoreSubject", :index_as => [:displayable, :facetable])

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
      :attributes=>{ :source=>HydraPbcore.config["institution"] },
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

    t.asset_date(path: 'pbcoreAssetDate', index_as: :displayable)

    t.contents(:path=>"pbcoreDescription", 
      :attributes=>{ 
        :descriptionType=>"Table of Contents",
        :descriptionTypeSource=>"pbcoreDescription/descriptionType",
        :descriptionTypeRef=>"http://pbcore.org/vocabularies/pbcoreDescription/descriptionType#table-of-contents",
        :annotation=>"Parts List"
      },
      :index_as => [:searchable, :displayable]
    )

    # This is only to display all genres
    t.genre(:path=>"pbcoreGenre", :index_as => [:displayable, :facetable])

    t.asset_type(:path=>"pbcoreAssetType", :index_as => [:searchable, :displayable, :facetable])

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
    t.relation(:path => "pbcoreRelation") do
      t.event_series(:path=>"pbcoreRelationIdentifier", :attributes=>{ :annotation=>"Event Series" })
      t.collection(:path=>"pbcoreRelationIdentifier", :attributes=>{ :annotation=>"Archival Collection" }) do
        t.uri(:path => {:attribute => "ref"})
        t.authority(:path => {:attribute => "source"})
      end
      t.series(:path=>"pbcoreRelationIdentifier", :attributes=>{ :annotation=>"Archival Series" }) do
        t.uri(:path => {:attribute => "ref"})
        t.authority(:path => {:attribute => "source"})
      end
      t.coll_num(:path=>"pbcoreRelationIdentifier", :attributes=>{ :annotation=>"Collection Number" })
      t.acc_num(:path=>"pbcoreRelationIdentifier", :attributes=>{ :annotation=>"Accession Number" })
      t.addl_coll(:path=>"pbcoreRelationIdentifier", :attributes=>{ :annotation=>"Additional Collection" })
    end
    t.series(:ref=>[:relation, :event_series], :index_as => [:searchable, :displayable, :facetable])
    t.collection(:ref=>[:relation, :collection], :index_as => [:searchable, :displayable, :facetable])
    t.collection_uri(:proxy=>[:relation, :collection, :uri], :index_as => [:displayable])
    t.collection_authority(:proxy=>[:relation, :collection, :authority], :index_as => [:displayable])
    t.archival_series(:ref=>[:relation, :series], :index_as => [:searchable, :displayable, :facetable])
    t.archival_series_uri(:proxy=>[:relation, :series, :uri], :index_as => [:displayable])
    t.archival_series_authority(:proxy=>[:relation, :series, :authority], :index_as => [:displayable])
    t.additional_collection(:ref=>[:relation, :addl_coll], :index_as => [:searchable, :displayable, :facetable])
    t.collection_number(:ref=>[:relation, :coll_num], :index_as => [:searchable, :displayable])
    t.accession_number(:ref=>[:relation, :acc_num], :index_as => [:searchable, :displayable])

    t.pbcoreCoverage
    # Terms for time and place
    t.event_place(:path=>"pbcoreCoverage/coverage", 
      :attributes => {:annotation=>"Event Place"},
      :index_as => [:searchable, :displayable]
    )
    t.event_date(:path=>"pbcoreCoverage/coverage", 
      :attributes => {:annotation=>"Event Date"},
      :index_as => [:dateable, :displayable]
    )


    # Creator names and roles
    t.creator(:path=>"pbcoreCreator") do
      t.name_(:path=>"creator")
      t.role_(:path=>"creatorRole", :attributes=>{ :source=>"PBCore creatorRole" })
    end
    t.creator_name(:ref=>[:creator, :name], :index_as => [:searchable, :displayable, :facetable])
    t.creator_role(:ref=>[:creator, :role], :index_as => [:searchable, :displayable])

    # Contributor names and roles
    t.contributor(:path=>"pbcoreContributor") do
      t.name_(:path=>"contributor")
      t.role_(:path=>"contributorRole", :attributes=>{ :source=>HydraPbcore.config["relator"] })
    end
    t.contributor_name(:ref=>[:contributor, :name], :index_as => [:searchable, :displayable, :facetable])
    t.contributor_role(:ref=>[:contributor, :role], :index_as => [:searchable, :displayable])

    # Publisher names and roles
    t.publisher(:path=>"pbcorePublisher") do
      t.name_(:path=>"publisher")
      t.role_(:path=>"publisherRole", :attributes=>{ :source=>"PBCore publisherRole" })
    end
    t.publisher_name(:ref=>[:publisher, :name], :index_as => [:searchable, :displayable, :facetable])
    t.publisher_role(:ref=>[:publisher, :role], :index_as => [:searchable, :displayable])

    t.note(:path=>"pbcoreAnnotation", :atttributes=>{ :annotationType=>"Notes" }, :index_as => [:searchable, :displayable])

    t.pbcoreRightsSummary do
      t.rightsSummary
    end
    t.rights_summary(:ref => [:pbcoreRightsSummary, :rightsSummary], :index_as => [:searchable, :displayable])

  end

  def self.xml_template
    builder = Nokogiri::XML::Builder.new do |xml|

      xml.pbcoreDescriptionDocument("xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
        "xsi:schemaLocation"=>"http://www.pbcore.org/PBCore/PBCoreNamespace.html") {

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
