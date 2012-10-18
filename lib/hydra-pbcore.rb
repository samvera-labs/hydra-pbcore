#require "hydra-pbcore/version"
require "nokogiri"
require "solrizer"
require "om"
require "active-fedora"

module HydraPbcore
  VERSION = "0.0.1"
  def self.version
    HydraPbcore::VERSION
  end
end

require "hydra-pbcore/methods"
require "hydra-pbcore/behaviors"
require "hydra-pbcore/datastream/document"
require "hydra-pbcore/datastream/instantiation"
require "hydra-pbcore/datastream/digital_document"
