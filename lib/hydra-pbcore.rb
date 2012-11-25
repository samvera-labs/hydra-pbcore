#require "hydra-pbcore/version"
require "nokogiri"
require "solrizer"
require "om"
require "active-fedora"

module HydraPbcore
  def self.version
    HydraPbcore::VERSION
  end
end

require "hydra-pbcore/methods"
require "hydra-pbcore/behaviors"
require "hydra-pbcore/templates"
require "custom_mapper"
require "hydra-pbcore/datastream/document"
require "hydra-pbcore/datastream/instantiation"
require "hydra-pbcore/datastream/deprecated/document"
require "hydra-pbcore/datastream/deprecated/digital_document"
require "hydra-pbcore/datastream/deprecated/instantiation"