require 'spec_helper'

describe VersionedProduct do
  describe '#create_version!' do
    let!(:first_version) { VersionedProduct.create(name: 'iPad', price: 100) }

    def perform
      first_version.create_version!(name: 'iPad 2')
    end
    
    it 'creates a new version' do
      expect { perform }.to change { VersionedProduct.count }.by(1)
    end

    it 'unsets current version on first version' do
      perform
      expect(first_version.reload).to_not be_is_current_version
    end

    describe 'the new version' do
      subject { perform }
      specify { expect(subject).to be_is_current_version }
      specify { expect(perform.version).to eq(1) }
      specify { expect(perform.name).to eq('iPad 2') }
      specify { expect(perform.price).to eq(100) }
    end
  end

  describe '#versions' do
    subject(:first_version) { VersionedProduct.create(name: 'iPad') }
    specify { expect(subject).to have(1).versions }

    context 'after creating a version' do
      before  { first_version.create_version!(name: 'iPad 2') }
      specify { expect(subject).to have(2).versions }
    end
  end
end
