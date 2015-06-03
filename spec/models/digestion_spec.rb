# == Schema Information
#
# Table name: digestions
#
#  id               :integer          not null, primary key
#  review_digest_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#  email            :string(255)
#

require 'rails_helper'

RSpec.describe Digestion, type: :model do
  let(:digestion) { FactoryGirl.create(:digestion) }
  let!(:notes) do
    5.times do
      note = FactoryGirl.create(:note)
      FactoryGirl.create(:notes_digestion, note: note, digestion: digestion)
    end
    Note.all
  end

  before(:each) do
    mailer = double
    allow(DigestionMailer).to receive(:digestion_email) { mailer }
    allow(mailer).to receive(:deliver)
  end

  context 'execute' do
    it 'should collect content for its notes' do
      call_count = 5
      allow_any_instance_of(Note).to receive(:collect_content) { call_count -= 1 }
      expect {
        digestion.execute
      }.to change{call_count}.from(5).to(0)
    end
  end
end
