require 'spec_helper'

describe HydraPbcore::Methods do

  before :each do
    @object = HydraPbcore::Datastream::Document.new  
  end

  describe ".remove_node" do

    it "should delete nodes given a term" do
      @object.insert_publisher "bar"
      @object.publisher.first.should == "bar"
      @object.remove_node :publisher
      @object.publisher.should be_empty      
    end

    it "should delete nodes all with their parents" do
      @object.is_part_of("foo", {:annotation => "Archival Collection"})
      @object.collection.first.should == "foo"
      @object.remove_node :collection, 0, {:include_parent? => TRUE} 
      @object.find_by_terms(:pbcoreRelation).should be_empty
    end

  end
  
end