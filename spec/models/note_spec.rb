# == Schema Information
#
# Table name: notes
#
#  id              :integer          not null, primary key
#  note_id         :integer
#  tags            :text             default([]), is an Array
#  note_created_at :datetime
#  created_at      :datetime
#  updated_at      :datetime
#  user_id         :integer
#

require 'rails_helper'

RSpec.describe Note, type: :model do

end
