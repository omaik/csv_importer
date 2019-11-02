# frozen_string_literal: true

class Import < ApplicationRecord
  has_one_attached :file

  enum status: { created: 'created', pending: 'pending', started: 'started', completed: 'completed' }

  validates :title, presence: true
  validates :file, attached: true, content_type: { in: 'text/csv', message: 'is not a CSV' }

  scope :created, -> { where(status: :created) }
  scope :started, -> { where(status: %i[pending started]).order(started_at: :desc) }
  scope :completed, -> { where(status: :completed).order(completed_at: :desc) }
end
