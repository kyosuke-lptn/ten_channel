require 'rails_helper'

RSpec.describe PostingThreadCategory, type: :model do
  it { is_expected.to validate_presence_of :posting_thread_id }
  it { is_expected.to validate_presence_of :category_id }
  it { is_expected.to belong_to :posting_thread }
  it { is_expected.to belong_to :category }
end
