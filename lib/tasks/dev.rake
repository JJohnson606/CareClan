desc "Fill the database tables with some sample data"
task sample_data: :environment do
  starting = Time.now

  # Clearing the existing data
  Post.delete_all
  User.delete_all
  


  # Pre-defined users
  predefined_users = [
    { email: "alice@example.com", password: "password", name: "Alice Smith", role: 0, trust: true, profile_picture: "Alice.jpeg" },
    { email: "bob@example.com", password: "password", name: "Bob Smith", role: 1, trust: true, profile_picture:  "Bob.jpeg" },
    { email: "carol@example.com", password: "password", name: "Carol Smith", role: 0, trust: false, profile_picture: "Carol.jpeg" },
    { email: "doug@example.com", password: "password", name: "Doug Smith", role: 2, trust: true, profile_picture:  "Doug.jpeg" },
  ]

  sample_posts = [
    { body: "Spent the morning in the garden. The tulips are in full bloom! Brings back memories of my first garden." },
    { body: "Had my physio session today. Feeling stronger and more mobile each day. Grateful for the support." },
    { body: "Joined a video call with the whole family yesterday. It's incredible how technology keeps us connected." },
    { body: "Found an old photo album from the '60s. Each picture tells a story. Would love to share these with you all." },
    { body: "Started a new book recommended by a friend here. It's a captivating historical novel. Reminds me of the stories my grandfather used to tell." },
    { body: "Today's music therapy session was uplifting. There's something about the old classics that just soothes the soul." },
    { body: "Attended a workshop on nutrition today. Learning to make healthier food choices, even at this age. It's never too late!" },
    { body: "As I sit by the window watching the sunset, I can't help but reflect on the beauty of life's simple pleasures. Feeling thankful." }
  ]


  # Creating predefined users
  predefined_users.each do |user_params|
    user = User.create!(user_params)
    sample_posts.each do |post_params|
      user.posts.create!(post_params)  # Posts are now directly associated with the user
    end
  end

  ending = Time.now
  puts "It took #{(ending - starting).to_i} seconds to create sample data."
  puts "There are now #{User.count} users and #{Post.count} posts."
end
