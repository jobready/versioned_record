require 'spec_helper'

describe Tag do
  let!(:versioned_product) { VersionedProduct.create(name: 'iPad', price: 100) }
  let!(:versioned_product_revision) { versioned_product.create_version!(name: 'iPad 2') }

  describe 'add a tag' do
    let!(:tag_a) { versioned_product.tags.create(name: 'Electronics') }
    let!(:tag_b) { versioned_product.tags.create(name: 'Consumer') }
    
    specify { expect(versioned_product_revision).to have(2).tags }
    specify { expect(tag_a.versioned_products.to_a).to eq([versioned_product_revision]) }
  end

end
