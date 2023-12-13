# == Schema Information
#
# Table name: identities
#
#  id            :integer          not null, primary key
#  access_token  :string
#  expires_at    :datetime
#  provider      :string
#  refresh_token :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer          not null
#
# Indexes
#
#  index_identities_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Identity < ApplicationRecord
  belongs_to :user
end
