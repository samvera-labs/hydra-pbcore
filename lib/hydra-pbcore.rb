#require "hydra-pbcore/version"
require "nokogiri"
require "solrizer"
require "om"
require "active-fedora"

module HydraPbcore
  extend ActiveSupport::Autoload

  DocumentNodes = [
    "pbcoreAssetType",
    "pbcoreAssetDate",
    "pbcoreIdentifier",
    "pbcoreTitle",
    "pbcoreSubject",
    "pbcoreDescription",
    "pbcoreGenre",
    "pbcoreRelation",
    "pbcoreCoverage",
    "pbcoreAudienceLevel",
    "pbcoreAudienceRating",
    "pbcoreCreator",
    "pbcoreContributor",
    "pbcorePublisher",
    "pbcoreRightsSummary",
    "pbcoreInstantiation",
    "pbcoreAnnotation",
    "pbcorePart",
    "pbcoreExtension",
  ]

  InstantiationNodes = [
    "instantiationIdentifier",
    "instantiationDate",
    "instantiationDimensions",
    "instantiationPhysical",
    "instantiationDigital",
    "instantiationStandard",
    "instantiationLocation",
    "instantiationMediaType",
    "instantiationGenerations",
    "instantiationFileSize",
    "instantiationTimeStart",
    "instantiationDuration",
    "instantiationDataRate",
    "instantiationColors",
    "instantiationTracks",
    "instantiationChannelConfiguration",
    "instantiationLanguage",
    "instantiationAlternativeModes",
    "instantiationEssenceTrack",
    "instantiationRelation",
    "instantiationRights",
    "instantiationAnnotation",
    "instantiationPart",
    "instantiationExtension",
  ]

  def self.version
    HydraPbcore::VERSION
  end

  # Returns a blank pbccoreDocument
  def self.blank
    xml = '<?xml version="1.0"?><pbcoreDescriptionDocument xmlns="http://www.pbcore.org/PBCore/PBCoreNamespace.html" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.pbcore.org/PBCore/PBCoreNamespace.html" xsi:schemaLocation="http://www.pbcore.org/PBCore/PBCoreNamespace.html"></pbcoreDescriptionDocument>'
    Nokogiri::XML(xml)
  end

  # Validates a supplied xml document against the PBCore schema.  This differs from 
  # HydraPbcore::Methods.valid? which validates self, instead of the supplied argument.
  # Argument must be a Nokogiri::XML::Document.
  def self.is_valid? xml
    xsd = Nokogiri::XML::Schema(open("http://pbcore.org/xsd/pbcore-2.0.xsd"))
    xsd.validate(xml)
  end

  autoload :Mapper
  autoload :Methods
  autoload :Conversions
  autoload :Behaviors
  autoload :Templates
  autoload :Datastream
end
