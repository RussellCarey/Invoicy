Fabricator(:invoice) do
    title "Test Title #{Faker::Number.number(digits: 5)}"
    issue_date Date.today
    due_date Date.today + 5.days
    status 0
    discount 0
    tax 0
    client_id 100
    user_id 100
end