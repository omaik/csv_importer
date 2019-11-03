# frozen_string_literal: true

class Import
end

FactoryBot.define do
  factory :import do
    title { "title#{Time.now.to_i}" }
    file { 'spec/fixtures/files/customers.csv' }
  end
end
