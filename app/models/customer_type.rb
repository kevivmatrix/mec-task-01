class CustomerType < ApplicationRecord
  has_many :customers, dependent: :nullify

  validates :name, presence: true, uniqueness: true
end
