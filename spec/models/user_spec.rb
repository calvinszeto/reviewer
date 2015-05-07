# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  auth_token :string(255)
#  created_at :datetime
#  updated_at :datetime
#  email      :string(255)
#

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  context 'evernote_date_filter' do
    it 'should return a filter to pull from last 7 days if no notes have yet been pulled' do
      expect(user.evernote_date_filter).to eq('created:day-7')
    end

    it 'should return a filter to pull since the latest note' do
      created_at = DateTime.new(2015,4,5,6,7,8,'-4')
      FactoryGirl.create(:note, created_at: created_at, user: user)
      expect(user.evernote_date_filter).to eq('created:20150405T100708Z')
    end
  end
end