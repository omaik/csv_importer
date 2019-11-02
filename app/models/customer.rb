# frozen_string_literal: true

class Customer < ApplicationRecord
  belongs_to :import
  validates :first_name, :last_name, presence: true, length: { minimum: 2 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
end
