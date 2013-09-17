require 'spec_helper'

describe HydraPbcore::Datastream::GenericFile do

  before :each do
    @object_ds = HydraPbcore::Datastream::GenericFile.new nil, nil
  end

  describe "extending Sufia::GenericFile field" do
    
    describe "#related_url" do
      it "should have getter and setters" do
        @object_ds.related_url.should == [""]
        @object_ds.related_url = "a related url"
        @object_ds.related_url.should == ["a related url"]
      end
    end

    describe "#based_near" do
      it "should have getter and setters" do
        @object_ds.based_near.should == [""]
        @object_ds.based_near = "a related url"
        @object_ds.based_near.should == ["a related url"]
      end
    end

    describe "#part_of" do
      it "should have getter and setters" do
        @object_ds.part_of.should == [""]
        @object_ds.part_of = "part of annotation"
        @object_ds.part_of.should == ["part of annotation"]
      end      
    end

    describe "#language" do
      it "should have getter and setters" do
        @object_ds.language.should == [""]
        @object_ds.language = "language"
        @object_ds.language.should == ["language"]
      end      
    end

    describe "#tag" do
      before :each do
        @object_ds.tag = "a tag"
      end
      it "should have getter and setters" do
        @object_ds.tag.should == ["a tag"]
      end
      it "should be a kind of subject" do
        @object_ds.subject.should == ["a tag"]
      end
      it "should be the same as rh_subject" do
        @object_ds.rh_subject.should == ["a tag"]
      end
    end

    describe "#description" do
      before :each do
        @object_ds.description = "foo"
      end
      it "should have getter and setters" do
        @object_ds.description.should == ["foo"]
      end
      it "should be the same as #summary" do
        @object_ds.summary.should == ["foo"]
      end
    end

    describe "#rights" do
      before :each do
        @object_ds.rights = "rights statement"
      end
      it "should have getters and setters" do
        @object_ds.rights.should == ["rights statement"]
      end
      it "should be the same as #rights_summary" do
        @object_ds.rights_summary.should == ["rights statement"]
      end
    end

    describe "#date_created" do
      before :each do
        @object_ds.date_created = "2001-11-13"
      end
      it "should have getters and setters" do
        @object_ds.date_created.should == ["2001-11-13"]
      end
      it "should be the same as #asset_date" do
        @object_ds.date_created.should == ["2001-11-13"]
      end
    end

    describe "#resource_type" do
      before :each do
        @object_ds.resource_type = "a resource type"
      end
      it "should be a term" do
        @object_ds.resource_type.should == ["a resource type"]
      end
      it "should be the same as #asset_type" do
        @object_ds.asset_type.should == ["a resource type"]
      end
    end

    describe "#identifier" do
      before :each do
        @object_ds.identifier = "a Sufia identifier"
      end
      it "should have getters and setters" do
        @object_ds.identifier.should == ["a Sufia identifier"]
      end
      it "should be the same as #pbc_id" do
        @object_ds.pbc_id.should == ["a Sufia identifier"]
      end
    end

  end

end