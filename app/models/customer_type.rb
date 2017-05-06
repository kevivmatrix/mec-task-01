class CustomerType < ApplicationRecord
  has_many :customers, dependent: :nullify
end
