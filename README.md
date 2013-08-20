# HydraPbcore

[![Build Status](https://travis-ci.org/awead/hydra-pbcore.png)](https://travis-ci.org/awead/hydra-pbcore)

A Hydra gem that offers PBCore datastream definitions using OM, as well as some other convenience
methods such as inserting xml templates into existing documents and reordering your PBCore xml 
elements so that you can export complete, valid PBCore documents.

## Installation

Add this line to your application's Gemfile:

    gem 'hydra-pbcore'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hydra-pbcore

## Usage

Use this with your hydra head to define a datastream in Fedora that will contain Pbcore xml.  Ex:

    MyModel < ActiveFedora::Base

      has_metadata :name => "descMetadata", :type => HydraPbcore::Datastream::Document

    end

Your descMetadata datastream will now have all the pbcore terms defined in HydraPbcore::Datastream::Document.

The HydraPbcore::Datastream::Instantiation datastream contains additional PBcore terms pertaining to 
pbcoreInstantiation nodes.  HydraPbcore supports an atomistic Fedora model where there are multiple
Fedora objects representing a single Pbcore document.  This supports a use case where multiple video
files are represented as individual Fedora objects with the Instantiation datastream.

### Atomistic Fedora Model

A parent pbcoreDocument object, with multiple instantiations, can be defined:

    MyPbcoreDocument < ActiveFedora::Base
      has_many :instantiations, :property => :is_part_of
      has_metadata :name => "descMetadata", :type => HydraPbcore::Datastream::Document
    end

Then, a child pbcoreInstantiation object with one parent pbcoreDocument is:

    MyPbcoreInstantiation < ActiveFedora::Base
      belongs_to :parent, :property => :is_part_of, :class_name => "MyPbcoreDocument"
      has_metadata :name => "descMetadata", :type => HydraPbcore::Datastream::Instantiation
    end

The objects can then be linked together using Fedora's RDF datastream via ActiveFedora's methods:

    > doc = MyPbcoreDocument.new
    > instantiation = MyPbcoreInstantiation.new
    > doc.instantiations << instantiation

### Additional Methods

Complete PBcore documents can be assembled with their related instantiations using some of HydraPbcore's 
convenience methods, which will reorder all nodes so the resulting document can be validated
according to the PBCore XML v.2 schema:

    > doc = HydraPbcore::Datastream::Document.new
    > instantiation1 = HydraPbcore::Datastream::Instantiation.new
    > instantiation2 = HydraPbcore::Datastream::Instantiation.new
    > pbcore = doc.to_pbcore_xml(instantiation1, instantiation2)
    > pbcore.valid_pbcore?
    => true

## New Changes

### version 3.1

As of 3.1, the pbcoreIdentifier is not included in the xml template.  This is so users may add their own identifier,
or multiple identifiers, with an optional annotation.  Documents will require at least one pbcoreIdentifier in order to
be valid.  You may specify this either by simply setting the value:

    doc.pbc_id = "1234"

Or by inserting a new one via the template:

    doc.insert_identifier("5678")

All identifiers will include the source attribute, which is required by the PBCore schema, and is given in the config.yml file.
An annotation may be added as a second argument to the identifier template.

## Testing

To run all the rspec tests, use:

    rspec spec

Sample xml documents are copied to tmp so you can see what the xml looks like that hydra-pbcore is generating.
These xml samples are compared to examples in spec/fixtures.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
