require 'spec_helper'

describe VersionedProduct do
  let!(:first_version) { VersionedProduct.create(name: 'iPad', price: 100) }

  describe '#create_version!' do
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

    context 'when created record is invalid' do
      it 'raises an error' do
        expect { first_version.create_version!(name: nil) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not change the current version flag on first version' do
        begin
          first_version.create_version!(name: nil)
        rescue
          expect(first_version.reload).to_not be_is_current_version
        end
      end
    end
  end

  describe '#create_version' do
    # TODO: Include examples from create_version!
    #
    context 'when created record is invalid' do
      it 'does not create a new version' do
        expect { first_version.create_version(name: 'f') }.to_not change { VersionedProduct.count }
      end

      it 'returns false' do
        expect(first_version.create_version(name: 'f')).to be_false
      end
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
