FactoryBot.define do
  factory :appza do
    association :user, factory: :admin_user

    name { "Authna Appza" }
    url { Faker::Internet.url(scheme: "https") }
    callback_url { Faker::Internet.url(scheme: "https") }
    accept_header { "application/drabkirn.appza.v1" }
    requires { Faker::Lorem.words(number: 3) }
    secret { SecureRandom.hex(15) }
  end
end
