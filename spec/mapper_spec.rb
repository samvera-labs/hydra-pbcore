require 'spec_helper'

describe HydraPbcore::Mapper do

  describe "#pbcore_date" do

    it "should return valid dates from only partial ones" do
      HydraPbcore::Mapper.pbcore_date('2003').should    == "2003-01-01T00:00:00Z"
      HydraPbcore::Mapper.pbcore_date('2009-07').should == "2009-07-01T00:00:00Z"
    end

    it "should return empty strings and not dates" do
      HydraPbcore::Mapper.pbcore_date('').should be_empty
    end

  end

end