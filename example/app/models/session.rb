class Session < ApplicationRecord
  encrypts :ip_address, :user_agent
  belongs_to :user
end
