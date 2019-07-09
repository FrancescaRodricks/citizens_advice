FactoryBot.define do
  factory :user do
    username { "John" }
    email { "john.doe@example.com" }
    password_digest { 'qwerty123' }
  end
end
