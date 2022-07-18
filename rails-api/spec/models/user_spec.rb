# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  it 'creates a user' do
    expect(user.id).not_to eq nil
  end
end
