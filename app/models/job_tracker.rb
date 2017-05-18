class JobTracker < ApplicationRecord
  extend Enumerize

  VALID_STATUSES = %w{ waiting completed failed }

  enumerize :status, in: VALID_STATUSES, default: "waiting", predicates: true

  belongs_to :trackable, polymorphic: true
end
