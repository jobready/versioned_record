require 'spec_helper'

describe Catalog do
  describe 'chained versioning' do
    let(:catalog) { Catalog.create(name: 'Products 2013') }
    let(:product) { VersionedProduct.create(name: 'Headphones', price: '200', catalog: catalog) }

    let(:new_product) { product.build_version }
    let(:new_catalog)     { new_product.catalog.build_version }

    before do
      new_catalog.name = 'Products 2014'
      new_product.association(:catalog).writer(new_catalog)
      new_product.save!
    end

    specify do
      expect(new_product).to be_persisted
      expect(new_product).to have(2).versions
      expect(new_product.catalog).to eq(new_catalog)
    end
  end
end

