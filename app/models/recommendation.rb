# == Schema Information
#
# Table name: recommendations
#
#  id               :integer          not null, primary key
#  busyness_level   :string
#  recommended_time :datetime
#  user_feedback    :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  gym_id           :integer          not null
#  user_id          :integer          not null
#
# Indexes
#
#  index_recommendations_on_gym_id   (gym_id)
#  index_recommendations_on_user_id  (user_id)
#
# Foreign Keys
#
#  gym_id   (gym_id => gyms.id)
#  user_id  (user_id => users.id)
#
class Recommendation < ApplicationRecord
  belongs_to :user
  belongs_to :gym
end
