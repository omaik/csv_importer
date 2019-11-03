# frozen_string_literal: true

class Customer < ApplicationRecord
  belongs_to :import

  validates :first_name, :last_name, presence: true, length: { minimum: 2 }
  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: true
  validates :date_of_birth,
            presence: true,
            inclusion: {
              in: (100.years.ago)..(18.years.ago),
              message: 'must be bigger than 18 and smaller than 100 years'
            }
end
