# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  preferred_end_time     :time
#  preferred_start_time   :time
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  attr_accessor :preferred_start_time, :preferred_end_time
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :recommendations

  validates :preferred_start_time, presence: true
  validates :preferred_end_time, presence: true

  validate :end_time_after_start_time

  private

  def end_time_after_start_time
    if preferred_end_time <= preferred_start_time
      errors.add(:preferred_end_time, "must be after the start time")
    end
  end
end
