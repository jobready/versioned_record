require 'spec_helper'

describe VersionedProduct do
  let!(:versioned_product) { VersionedProduct.create(name: 'iPad', price: 100) }
  let!(:versioned_product_revision) { versioned_product.create_version!(name: 'iPad 2') }

  describe 'creation via association' do
    subject(:sale) { versioned_product.sales.create(purchaser: 'Dan Draper') }

    specify 'that the sale belongs to the specific version' do
      expect(subject.versioned_product(true)).to eq(versioned_product)
    end
  end

  describe 'create directly' do
    let!(:sale) { Sale.create(purchaser: 'Dan Draper', versioned_product: versioned_product_revision) }

    specify 'that the comment belongs to the specific version' do
      expect(sale.versioned_product(true)).to eq(versioned_product_revision)
    end

    context 'create another version of the parent' do
      let!(:vp3) { versioned_product_revision.create_version!(name: 'iPad 3') }

      specify 'that the comment STILL belongs to the specific version' do
        expect(sale.versioned_product(true)).to eq(versioned_product_revision)
      end
    end
  end
end

