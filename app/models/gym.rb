# == Schema Information
#
# Table name: gyms
#
#  id              :integer          not null, primary key
#  location        :string
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  google_place_id :string
#
class Gym < ApplicationRecord
  has_many :busy_times
  has_many :recommendations
  
end
