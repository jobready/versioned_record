require 'spec_helper'

describe VersionedProduct do
  describe 'installation' do
    let!(:versioned_product) { VersionedProduct.create(name: 'iPad', price: 100) }
    let!(:versioned_product_revision) { versioned_product.create_version!(name: 'iPad 2') }

    describe 'creation via association' do
      let!(:installation) { versioned_product.create_installation!(installed_by: 'Roger Moore') }

      specify 'that the installation belongs to the latest version' do
        expect(installation.versioned_product).to eq(versioned_product_revision)
      end

      specify 'that the latest version of the product has the installation set after reload' do
        expect(versioned_product_revision.reload.installation).to eq(installation)
      end

      specify 'that the previous version of the product has the installation set after reload' do
        expect(versioned_product.reload.installation).to eq(installation)
      end
    end

    describe 'direct creation' do
      let(:installation) { Installation.new(installed_by: 'Sean Connery') }
      subject { VersionedProduct.create(name: 'iPad', price: 100, installation: installation) }

      specify 'that the installation is set and persisted' do
        expect(subject.reload.installation).to eq(installation)
      end
    end

    describe 'simple test' do
      let(:installation) { Installation.new(installed_by: 'Sean Connery') }
      subject { Office.create(address: 'CQ Sydney', installation: installation) }

      specify 'that the installation is set and persisted' do
        expect(subject.reload.installation).to eq(installation)
      end
    end
  end
end
