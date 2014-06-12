require 'spec_helper'

describe VersionedProduct, :timestamps do
  before               { Timecop.freeze(time1) }
  after                { Timecop.return }
  let(:time1)          { '2014-06-06 10:00'.to_time }
  let(:company)        { Company.create(name: 'Acme Corp') }
  let!(:first_version) { VersionedProduct.create(name: 'iPad', price: 100, company: company) }

  specify { expect(first_version.created_at).to eq(time1.utc) }

  describe 'creating a new version at a later time' do
    before                { Timecop.freeze(time2) }
    let(:time2)           { '2014-06-08 10:00'.to_time }
    let!(:second_version) { first_version.create_version! }

    specify { expect(first_version.created_at).to eq(time1.utc) }
    specify { expect(second_version.created_at).to eq(time2.utc) }
  end
end



