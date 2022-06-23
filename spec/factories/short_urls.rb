FactoryBot.define do
  factory :short_url do
    original_url { Faker::Internet.url }
  end
end