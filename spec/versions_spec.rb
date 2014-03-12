require 'spec_helper'

describe VersionedProduct do
  let!(:first_version) { VersionedProduct.create(name: 'iPad', price: 100) }

  shared_examples 'successful version creation' do
    it 'creates a new version' do
      expect { perform }.to change { VersionedProduct.count }.by(1)
    end

    it 'unsets current version on first version' do
      perform
      expect(first_version.reload).to_not be_is_current_version
    end

    describe 'the new version' do
      subject { perform.reload }
      specify { expect(subject).to be_is_current_version }
      specify { expect(subject.version).to eq(1) }
      specify { expect(subject.name).to eq('iPad 2') }
      specify { expect(subject.price).to eq(100) }
      specify { expect(subject).to be_valid }
      specify { expect(subject).to be_persisted }
    end
  end

  describe '#create_version!' do
    def perform
      first_version.create_version!(name: 'iPad 2')
    end

    include_examples 'successful version creation'
    
    context 'when created record is invalid' do
      it 'raises an error' do
        expect { first_version.create_version!(name: nil) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not change the current version flag on first version' do
        begin
          first_version.create_version!(name: nil)
        rescue
          expect(first_version.reload).to be_is_current_version
        end
      end
    end
  end

  describe '#create_version' do
    def perform
      first_version.create_version(name: 'iPad 2')
    end

    include_examples 'successful version creation'

    context 'when created record is invalid' do
      it 'does not create a new version' do
        expect { first_version.create_version(name: 'f') }.to_not change { VersionedProduct.count }
      end

      describe 'create result' do
        subject { first_version.create_version(name: 'f') }

        specify { expect(subject).to_not be_valid }
        specify { expect(subject).to_not be_persisted }
      end
    end
  end

  describe '#build_version' do
    context 'with attributes provided directly' do
      def perform
        first_version.build_version(name: 'iPad 2').tap do |new_version|
          new_version.save!
        end
      end

      include_examples 'successful version creation'
      
      context 'when created record is invalid' do
        it 'does not create a new version' do
          expect {
            new_version = first_version.build_version(name: 'f')
            new_version.save
          }.to_not change { VersionedProduct.count }
        end

        describe 'create result' do
          subject do
            first_version.build_version(name: 'f').tap do |new_version|
              new_version.save
            end
          end

          specify { expect(subject).to_not be_valid }
          specify { expect(subject).to_not be_persisted }
        end
      end
    end

    context 'with attributes provided after initialization' do
      def perform
        first_version.build_version.tap do |new_version|
          new_version.name = 'iPad 2'
          new_version.save!
        end
      end

      include_examples 'successful version creation'

      context 'when created record is invalid' do
        it 'does not create a new version' do
          expect {
            new_version = first_version.build_version
            new_version.name = 'f'
            new_version.save
          }.to_not change { VersionedProduct.count }
        end

        describe 'create result' do
          subject do
            first_version.build_version.tap do |new_version|
              new_version.name = 'f'
              new_version.save
            end
          end

          specify { expect(subject).to_not be_valid }
          specify { expect(subject).to_not be_persisted }
        end
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
