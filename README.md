# VersionedRecord

[![Code Climate](https://codeclimate.com/github/jobready/versioned_record.png)](https://codeclimate.com/github/jobready/versioned_record)
[![Build Status](https://travis-ci.org/jobready/versioned_record.png?branch=develop)](https://travis-ci.org/jobready/versioned_record)

[RDocs](http://rdoc.info/github/jobready/versioned_record/master/frames)

Versioned Record allows the creation of multiple versions of an active record that share an ID.
The version and ID columns of a record form a composite primary key and as such this gem relies on the
composite_primary_keys gem.

Why another versioning tool for ActiveRecord? Mainly because this gem does not rely on serializing data or storing of
multiple attributes in a single column. It uses databases as they were intended which means it is fast, reliable and flexible.

## Installation

Add this line to your application's Gemfile:

    gem 'versioned_record'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install versioned_record

## Usage

### Setting up your table

To create a versioned record, start by adding the `versioned: true` option to your migration and then (re)running.

    create_table :products, versioned: true do |t|
      t.string :name
      t.decimal :price
    end

The versioned option will create the `id`, `version` and `is_current_version` columns and create a composite primary key on the id and version columns.

Next, include the VersionedRecord module in your ActiveRecord model

    class Product < ActiveRecord::Base
      include VersionedRecord
    end

### Creating records and versions

Creating a record happens as normal.

    product = Product.create(name: 'Coffee Cup', price: 4.99)

The product will have `version` set to 0 and `is_current_version` set to true

    product.version => 0
    product.is_current_version? => true

To create a version simply call `create_version!` on the record.

    product_v2 = product.create_version!(price: 5.99)

Note that any attributes not specified in the `create_version!` call will be copied from the previous version.

    product_v2.name => 'Coffee Cup'

Also, the `is_current_version` flag is unset for the old version and set for the new one

    product.is_current_version? => false
    product_v2.is_current_version? => true

## TODO: Associations


## Database Support

Right now, only PostgreSQL has been tested. MySQL may or may not work but if you'd like to test/add support please fork and contribute!

## Author

Dan Draper, dan at codehire dot com, [Codehire](http://www.codehire.com/), [@danieldraper](http://www.twitter.com/danieldraper)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
