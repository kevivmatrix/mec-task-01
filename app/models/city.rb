class City < ApplicationRecord
  has_many :customers, dependent: :nullify
end
