Fabricator(:client) do
    email { Faker::Internet.email }
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
    address_number {Faker::Number.number(digits: 3)}
    address_street "Test Street"
    address_city "Test City"
    address_county "Test County"
    address_postcode "PO212CG"
    user_id 1
end
