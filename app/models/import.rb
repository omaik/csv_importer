class Import < ApplicationRecord
  has_one_attached :file

  enum status: { created: 'created', pending: 'pending', started: 'started', completed: 'completed' }

  validates :title, presence: true
  validates :file, attached: true, content_type: { in: 'text/csv', message: 'is not a CSV' }
end
