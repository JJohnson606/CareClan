desc "Fill the database tables with some sample data"
task sample_data: :environment do
  starting = Time.now

  # Clearing the existing data
  User.delete_all

  # Pre-defined users
  predefined_users = [
    { email: "alice@example.com", password: "password", name: "Alice Smith", role: 0, trust: true, profile_picture: UiFaces.woman},
    { email: "bob@example.com", password: "password", name: "Bob Smith", role: 1, trust: true },
    { email: "carol@example.com", password: "password", name: "Carol Smith", role: 0, trust: false },
    { email: "doug@example.com", password: "password", name: "Doug Smith", role: 2, trust: true }
  ]

  # Creating predefined users
  predefined_users.each do |user_params|
    User.create!(user_params)
  end

  ending = Time.now
  puts "It took #{(ending - starting).to_i} seconds to create sample data."
  puts "There are now #{User.count} users."
end
