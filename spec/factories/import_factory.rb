# frozen_string_literal: true

FactoryBot.define do
  factory :import do
    title { 'test' }

    before :create do |import|
      import.file.attach(io: StringIO.new, filename: 'nothing.csv')
    end
  end
end
