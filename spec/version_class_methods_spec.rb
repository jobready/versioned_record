require 'spec_helper'

describe VersionedProduct do
  describe '::create' do
    let(:record) { VersionedProduct.create(name: 'Macbook Pro') }

    specify do
      expect(record).to be_is_current_version
      expect(record.version).to eq(0)
    end
  end

  describe '::find' do
    context 'a single non-array argument' do
      it 'retrieves the latest version with the given ID' do
        expect(VersionedProduct).to receive(:find_current).with(1)
        VersionedProduct.find(1)
      end
    end

    context 'a single array argument' do
      it 'retrieves the latest version with the given ID' do
        expect(ActiveRecord::Base).to receive(:find).with([1, 0])
        VersionedProduct.find([1, 0])
      end
    end

    context 'multiple arguments' do
      it 'retrieves the latest version with the given ID' do
        expect(ActiveRecord::Base).to receive(:find).with(1, 0)
        VersionedProduct.find(1, 0)
      end
    end
  end

  describe 'scopes' do
    let!(:first_version)  { VersionedProduct.create(name: 'Macbook Pro') }
    let!(:second_version) { first_version.create_version!(name: 'Macbook Retina') }

    describe '::find_current' do
      it 'finds the latest version' do
        expect(VersionedProduct.find_current(first_version.id)).to eq(second_version)
      end

      context 'where no matching record exists' do
        it 'finds the latest version' do
          expect { VersionedProduct.find_current(0) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    describe '::current_versions' do
      it 'returns only the current version' do
        expect(VersionedProduct.current_versions).to eq([second_version])
      end
    end

    describe '::exclude_current' do
      it 'returns only the current version' do
        expect(VersionedProduct.exclude_current).to eq([first_version])
      end
    end

    describe '::exclude' do
      it 'returns everything but the excluded record' do
        expect(VersionedProduct.exclude(first_version)).to eq([second_version])
      end
    end
  end
end
