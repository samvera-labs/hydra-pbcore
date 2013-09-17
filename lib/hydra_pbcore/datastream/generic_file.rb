module HydraPbcore::Datastream
class GenericFile < HydraPbcore::Datastream::Document

  # Use our existing HydraPbcore::Datastream::Document terminology
  use_terminology HydraPbcore::Datastream::Document

  # Add in the extra bits required for Sufia
  extend_terminology do |t|
    t.resource_type(:proxy=>[:asset_type])
    t.description(:proxy=>[:summary])
    t.date_created(:proxy=>[:asset_date])
    t.tag(:proxy=>[:rh_subject])
    t.rights(:proxy=>[:rights_summary])
    t.identifier(:proxy=>[:pbc_id])

    t.related_url(:path=>"pbcoreAnnotation", :atttributes=>{ :annotationType=>"Related Url" }, :index_as => [:displayable])
    t.based_near(:path=>"pbcoreAnnotation", :atttributes=>{ :annotationType=>"Based Near" }, :index_as => [:displayable])
    t.part_of(:path=>"pbcoreAnnotation", :atttributes=>{ :annotationType=>"Part Of" }, :index_as => [:displayable])
    t.language(:path=>"pbcoreAnnotation", :atttributes=>{ :annotationType=>"Language" }, :index_as => [:displayable])
  end

end
end