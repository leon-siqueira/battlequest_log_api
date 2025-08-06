require 'rails_helper'

RSpec.describe Quest, type: :model do
  let(:object) { build(:quest, logged_id: 'q123') }

  context 'validations' do
    it 'accepts valid format' do
      expect(object).to be_valid
    end

    it 'rejects invalid format' do
      object.logged_id = 'abc123'
      expect(object).not_to be_valid
      expect(object.errors[:logged_id]).to include('must be in the format "q<numeric_id>"')
    end
  end
  it 'sets numeric id to what comes after q on the logged_id before saving' do
    expect(object.id).to be_nil
    object.save
    expect(object.id).to eq(123)
  end
end
