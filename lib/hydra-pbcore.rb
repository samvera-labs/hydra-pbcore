#require "hydra-pbcore/version"
require "nokogiri"
require "solrizer"
require "om"
require "active-fedora"

module HydraPbcore

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
end

require "hydra-pbcore/methods"
require "hydra-pbcore/conversions"
require "hydra-pbcore/behaviors"
require "hydra-pbcore/templates"
require "hydra-pbcore/mapper"
require "hydra-pbcore/datastream/document"
require "hydra-pbcore/datastream/instantiation"
require "hydra-pbcore/datastream/deprecated/document"
require "hydra-pbcore/datastream/deprecated/digital_document"
require "hydra-pbcore/datastream/deprecated/instantiation"