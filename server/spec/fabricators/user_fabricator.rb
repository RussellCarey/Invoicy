Fabricator(:user) do
    email { Faker::Internet.email }
    password { Faker::String.random(length: 8) }
end