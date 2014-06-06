require 'spec_helper'

describe User do
  let(:company) { Company.create!(name: 'Google') }
  let(:user)    { User.create!(name: 'Lauren', entity: company) }

  specify 'that the company is set as the entity' do
    expect(user.entity).to eq(company)
  end

  describe 'a new version of the company is created' do
    let!(:new_company) { company.create_version!(name: 'Google World Domination') }

    specify 'that the company is still set as the entity' do
      expect(user.reload.entity).to eq(new_company)
    end
  end
end
