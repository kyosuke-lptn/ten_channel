require 'rails_helper'

RSpec.describe PostingThread, type: :model do
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_length_of(:title).is_at_most(100) }
  it { is_expected.to validate_length_of(:description).is_at_most(500) }
  it { is_expected.to belong_to :user }
end
