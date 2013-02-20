# HydraPbcore

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
There are also two additional datastream definitions:

* HydraPbcore::Datastream::DigitalDocument
* HydraPbcore::Datastream::Instantiation

DigitalDocument datastreams have the exact same terms as Document, except that there is no default physical 
pbcoreInstantiation.  The Document datastreams comes with a single instantiation that represents a tape
or other physical entity.  DigitalDocument datastreams assume born-digital content and must have added
instantiations.  These instantiations are defined in the Instantiation datastream.

### Additional Methods

HydraPbcore comes with a couple of additional features such as ordering your xml nodes so that your xml will 
validate against the PBCore XML v.2 schema.  Additionally, there are several template methods that can be used
to insert additional terms into your xml documents, such as contributors, publishers, as well as next and previous
fields that specify which files come before and after one another in a multi-part born-digital video.

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
