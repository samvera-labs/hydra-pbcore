require 'spec_helper'

describe HydraPbcore::Templates do
  
  before :each do 
    class TestClass

      class_attribute :institution, :relator, :address
      self.institution = "Rock and Roll Hall of Fame and Museum"
      self.relator     = "MARC relator terms"
      self.address     = "Rock and Roll Hall of Fame and Museum,\n2809 Woodland Ave.,\nCleveland, OH, 44115\n216-515-1956\nlibrary@rockhall.org"
      
      def self.define_template arg
      end

      include HydraPbcore::Templates
    end
    @test = TestClass.new
  end

  describe "#digital_instantiation" do
    it "should return a template for a digital instantiaion" do
      save_template @test.digital_instantiation, "digital_instantiation_template.xml"
      tmp_file_should_match_exemplar("digital_instantiation_template.xml")
    end
  end

  describe "#physical_instantiation" do
    it "should create a template for physical instantiaions such as tapes" do
      save_template @test.physical_instantiation, "physical_instantiation_template.xml"
      tmp_file_should_match_exemplar("physical_instantiation_template.xml")
    end
  end


end
