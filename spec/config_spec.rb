require "spec_helper"

describe "HydraPbcore configuration" do

  #after :each do
  #  HydraPbcore.config["institution"].should == "Rock and Roll Hall of Fame and Museum"
  #  HydraPbcore.config["relator"].should == "MARC relator terms"
  #  HydraPbcore.config["address"].should == "Rock and Roll Hall of Fame and Museum,\n2809 Woodland Ave.,\nCleveland, OH, 44115\n216-515-1956\nlibrary@rockhall.org"
  #end

  describe "without a config file" do

    before :each do
      `rm -Rf config`
    end

    it "should have a value for the institution" do
      HydraPbcore.config["institution"].should == "Rock and Roll Hall of Fame and Museum"
    end

    it "should have a value for the relator" do
      HydraPbcore.config["relator"].should == "MARC relator terms"
    end

    it "should have a value for the relator" do
      HydraPbcore.config["address"].should == "Rock and Roll Hall of Fame and Museum,\n2809 Woodland Ave.,\nCleveland, OH, 44115\n216-515-1956\nlibrary@rockhall.org"
    end
    
  end

  describe "with a complete config file" do

    before :each do
      `rm -Rf config`
      `mkdir config`
      config = {
        "institution" => "Rock and Roll Hall of Fame and Museum",
        "relator"     => "MARC relator terms",
        "address"     => "Rock and Roll Hall of Fame and Museum,\n2809 Woodland Ave.,\nCleveland, OH, 44115\n216-515-1956\nlibrary@rockhall.org"
      }
      f = File.new("config/pbcore.yml", "w")
      f << config.to_yaml
      f.close
    end

    it "should have a value for the institution" do
      HydraPbcore.config["institution"].should == "Rock and Roll Hall of Fame and Museum"
    end

    it "should have a value for the relator" do
      HydraPbcore.config["relator"].should == "MARC relator terms"
    end

    it "should have a value for the relator" do
      HydraPbcore.config["address"].should == "Rock and Roll Hall of Fame and Museum,\n2809 Woodland Ave.,\nCleveland, OH, 44115\n216-515-1956\nlibrary@rockhall.org"
    end

  end

  describe "with a incomplete config file" do

    before :all do
      `rm -Rf config`
      `mkdir config`
      config = {
        "institution" => "Rock and Roll Hall of Fame and Museum"
      }
      f = File.new("config/pbcore.yml", "w")
      f << config.to_yaml
      f.close
    end

    it "should have a value for the institution" do
      HydraPbcore.config["institution"].should == "Rock and Roll Hall of Fame and Museum"
    end

    it "should have a value for the relator" do
      HydraPbcore.config["relator"].should == "MARC relator terms"
    end

    it "should have a value for the relator" do
      HydraPbcore.config["address"].should == "Rock and Roll Hall of Fame and Museum,\n2809 Woodland Ave.,\nCleveland, OH, 44115\n216-515-1956\nlibrary@rockhall.org"
    end

  end


end