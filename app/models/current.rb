class Current < ActiveSupport::CurrentAttributes
  attribute :user, :account, :ip_address, :user_agent
end
