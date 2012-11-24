# :nodoc
require "hydra-pbcore"
require "debugger"
require "equivalent-xml"

RSpec.configure do |config|
  config.color = true
end

def fixture(file)
  File.new(File.join(File.dirname(__FILE__), 'fixtures', file))
end

def sample(file)
  File.new(File.join('tmp', file))
end

def save_template input, filename
  out = File.new(File.join("tmp", filename), "w")
  out.write(input.to_s)
  out.close
end

def equivalent_xml_files(file)
  f = Nokogiri::XML(fixture file)
  s = Nokogiri::XML(sample file)
  EquivalentXml.equivalent?(
    f, s, 
    opts = { :element_order => false, :normalize_whitespace => true }
  )
end

def random_string
  (0...50).map{ ('a'..'z').to_a[rand(26)] }.join
end