require 'spec_helper'

describe VersionedProduct do
  describe '#create_version!' do
    let!(:first_version) { VersionedProduct.create(name: 'iPad', version: 0) }
    
    it 'creates a new version' do
      expect { first_version.create_version!(name: 'iPad 2') }.to change { VersionedProduct.count }.by(1)
    end
  end
end
