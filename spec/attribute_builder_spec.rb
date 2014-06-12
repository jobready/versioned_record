require 'spec_helper'

describe VersionedRecord::AttributeBuilder do
  describe '#original_attributes' do
    let(:creation_attrs) do
      {
        name: 'Foo',
        price: 100,
        company_id: 1,
        catalog_id: 2,
        catalog_version: 0
      }
    end

    let(:record) { VersionedProduct.create!(creation_attrs) }
    subject      { described_class.new(record) }

    specify 'that original attributes does not include timestamps' do
      expect(subject.original_attributes[:created_at]).to be_nil
      expect(subject.original_attributes[:updated_at]).to be_nil
    end

    specify 'that the original attributes contain all relevant attributes' do
      expect(subject.original_attributes).to eq(
        creation_attrs.merge(id: record._id, version: 0, is_current_version: true)
      )
    end
  end
end

