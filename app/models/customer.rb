class Customer < ApplicationRecord
    has_many :customer_transaction
    has_many :point
    has_many :customer_reward

end
