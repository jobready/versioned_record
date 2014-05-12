require 'spec_helper'

describe Comment do
  let!(:versioned_product) { VersionedProduct.create(name: 'iPad', price: 100) }
  let!(:versioned_product_revision) { versioned_product.create_version!(name: 'iPad 2') }

  describe 'creation via association' do
    subject(:comment) { versioned_product.comments.create(content: 'Awesome') }

    specify 'that the comment belongs to the latest version' do
      expect(subject.versioned_product).to eq(versioned_product_revision)
    end
  end

  describe 'create directly' do
    let!(:comment) { Comment.create(content: 'Awesome', versioned_product: versioned_product) }

    specify 'that the comment belongs to the latest version' do
      expect(comment.versioned_product(true)).to eq(versioned_product_revision)
    end

    context 'create another version of the parent' do
      let!(:vp3) { versioned_product_revision.create_version!(name: 'iPad 3') }

      specify 'that the comment STILL belongs to the latest version' do
        expect(comment.versioned_product(true)).to eq(vp3)
      end
    end
  end
end

