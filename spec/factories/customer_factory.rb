FactoryBot.define do
  factory :customer do
    first_name { 'Test' }
    last_name { 'Test' }
    sequence(:email) { |n| "test#{n}@test.com" }
    date_of_birth { '04/01/1996' }
    import
  end
end
