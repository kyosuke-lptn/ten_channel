require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to validate_length_of(:name).is_at_most(30) }
  it { is_expected.to validate_length_of(:password).is_at_least(6).is_at_most(128) }
  it { is_expected.to have_many(:posting_threads) }
  it { is_expected.to have_many(:comments) }
  it { is_expected.to have_many(:likes) }
end
