class Client < ApplicationRecord
    has_many :customer
    has_many :customer_transaction
end
