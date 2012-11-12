require 'spec_helper'

describe Solrizer::FieldMapper::Default do

  describe "#pbcore_date" do

    it "should return valid dates from only partial ones" do
      Solrizer::FieldMapper::Default.pbcore_date('2003').should    == "2003-01-01"
      Solrizer::FieldMapper::Default.pbcore_date('2009-07').should == "2009-07-01"
    end

  end

end