require 'spec_helper'

describe VersionedProduct do
  let!(:versioned_product) { VersionedProduct.create(name: 'iPad', price: 100) }
  let!(:versioned_product_revision) { versioned_product.create_version!(name: 'iPad 2') }

  describe 'office' do
    describe 'creation via association' do
      let!(:office) { Office.create!(address: 'Circular Quay, Sydney') }

      before { versioned_product.office = office }

      specify "that the office's versioned product is the latest version" do
        expect(office.reload.versioned_product).to eq(versioned_product_revision)
      end

      specify 'that the previous version of the product has the office set after reload' do
        expect(versioned_product.reload.office).to eq(office)
      end

      specify 'that the latest version of the product has the office set after reload' do
        expect(versioned_product_revision.reload.office).to eq(office)
      end
    end
  end
end

