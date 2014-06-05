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
    let!(:a_v0) { VersionedProduct.create(name: 'Macbook Pro') }
    let!(:a_v1) { a_v0.create_version!(name: 'Macbook Retina') }
    let!(:a_v2) { a_v1.create_version!(name: 'Macbook Retina Sick') }
    let!(:b_v0) { VersionedProduct.create(name: 'Macbook Air') }
    let!(:b_v1) { b_v0.create_version!(name: 'Macbook Air 2') }

    describe '::find_current' do
      it 'finds the latest version' do
        expect(VersionedProduct.find_current(a_v0.id)).to eq(a_v2)
      end

      context 'where no matching record exists' do
        it 'finds the latest version' do
          expect { VersionedProduct.find_current(0) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    describe '::current_versions' do
      it 'returns only the current version' do
        expect(VersionedProduct.current_versions).to eq([a_v2, b_v1])
      end
    end

    describe '::exclude_current' do
      it 'returns only the current version' do
        expect(VersionedProduct.exclude_current.order(:id, :version)).to eq([a_v0, a_v1, b_v0])
      end
    end

    describe '::exclude' do
      it 'returns everything but the excluded record' do
        expect(b_v1.versions.exclude(b_v1)).to eq([b_v0])
      end
    end
  end
end
