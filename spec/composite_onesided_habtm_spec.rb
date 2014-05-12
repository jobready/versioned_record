require 'spec_helper'

describe Package do
  let!(:versioned_product) { VersionedProduct.create(name: 'iPad', price: 100) }
  let!(:versioned_product_revision) { versioned_product.create_version!(name: 'iPad 2') }

  describe 'creation via association' do
    subject(:package) { versioned_product.packages.create!(dimensions: '100x100') }

    # TODO: This is failing because the version is not getting set when creating the record in the join table
    specify 'that the package belongs to the specific version' do
      expect(subject.versioned_products(true).to_a).to eq([versioned_product])
    end
  end
end

