# == Schema Information
#
# Table name: busy_times
#
#  id             :integer          not null, primary key
#  busyness_level :string
#  day_of_week    :string
#  hour           :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  gym_id         :integer          not null
#
# Indexes
#
#  index_busy_times_on_gym_id  (gym_id)
#
# Foreign Keys
#
#  gym_id  (gym_id => gyms.id)
#
class BusyTime < ApplicationRecord
  belongs_to :gym

end
