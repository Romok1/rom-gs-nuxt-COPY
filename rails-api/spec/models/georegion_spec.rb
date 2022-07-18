require 'rails_helper'

RSpec.describe Georegion, type: :model do
  describe 'country' do
    let(:country) { 
      build(:country, name: 'test country', iso: 'test_iso', m49: 'test m49', georegion_type: build(:georegion_type, name: 'country')) 
    }
    
    context 'validation' do
      it 'passes if it has a name, m49, ISO' do
        expect(country.valid?).to eq true
      end

      it 'fails if it has no iso' do
        country.iso = nil
        expect(country.valid?).not_to eq true
      end

      it 'fails if it has no m49' do
        country.m49 = nil
        expect(country.valid?).not_to eq true
      end

      it 'fails if it has no region' do
        country.georegion_type = nil
        expect(country.valid?).not_to eq true
      end
    end
  end

  describe 'region' do
    let(:region) { 
      build(:region, name: 'test region', georegion_type: build(:georegion_type, name: 'region')) 
    }

    context 'validation' do
      it 'passes if it has a name' do
        expect(region.valid?).to eq true
      end

      it 'fails if it has no region' do
        region.georegion_type = nil
        expect(region.valid?).not_to eq true
      end
    end
  end
end
