require 'spec_helper'

describe VersionedProduct do
  # TODO: This might be a sep spec as well!
  describe 'preservation across versioning' do
    let(:installation) { Installation.create(installed_by: 'Sean Connery') }
    let(:container)    { Container.create(name: 'A Container') }

    let!(:versioned_product) do
      VersionedProduct.create(
        name: 'iPad',
        price: 100,
        installation: installation,
        container: container
      )
    end

    let!(:comment) { versioned_product.comments.create(content: 'Foo') }

    specify 'the versioned product has its associations set' do
      versioned_product.reload
      expect(versioned_product.installation).to eq(installation)
      expect(versioned_product.container).to eq(container)
      expect(versioned_product).to have(1).comment
    end

    describe 'build a new version of the product' do
      let(:new_version) { versioned_product.build_version }
      
      specify 'that the installation is still set' do
        expect(new_version.installation).to eq(installation)
      end

      specify 'that the container is NOT set (because its a composite relationship)' do
        expect(new_version.container).to be_nil
      end

      specify 'thet the comments are still set' do
        expect(new_version.comments).to include(comment)
        expect(new_version).to have(1).comment
      end
    end

    describe 'create a new version of the product' do
      let(:new_version) { versioned_product.create_version }
      
      specify 'that the installation is still set' do
        expect(new_version.installation).to eq(installation)
      end

      specify 'thet the comments are still set' do
        expect(new_version.comments).to include(comment)
        expect(new_version).to have(1).comment
      end
    end
  end
end
