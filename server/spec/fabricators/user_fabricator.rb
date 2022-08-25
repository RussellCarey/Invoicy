Fabricator(:user) do
    email { Faker::Internet.email }
    password { Faker::String.random(length: 8) }
    is_admin false
    confirmed_at "20/03/2021"
end