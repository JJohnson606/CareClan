desc "Fill the database tables with some sample data"
task sample_data: :environment do
  starting = Time.now

  # Clearing the existing data
  MedicalRecord.delete_all
  Approval.delete_all
  Comment.delete_all
  Post.delete_all
  User.delete_all

  # Pre-defined users
  predefined_users = [
    { email: "alice@example.com", password: "password", name: "Alice Smith", role: 0, trust: true, profile_picture: "Alice.jpeg" },
    { email: "bob@example.com", password: "password", name: "Bob Smith", role: 1, trust: true, profile_picture: "Bob.jpeg" }, 
    { email: "carol@example.com", password: "password", name: "Carol Smith", role: 2, trust: false, profile_picture: "Carol.jpeg" },
    { email: "doug@example.com", password: "password", name: "Doug Smith", role: 2, trust: true, profile_picture: "Doug.jpeg" },
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

  sample_comments = [
    { body: "Absolutely love this! Reminds me of my own experiences." },
    { body: "So inspiring! Thank you for sharing." }, 
    { body: "This is wonderful. Made my day!" },
    { body: "Beautiful words. Can't wait to hear more about it." }
  ]

  sample_approvals = [true, false]

  sample_medical_records = [
  { record_type: 'Basic Metabolic Panel', record_date: Date.today - 10, notes: 'Normal range' },
  { record_type: 'Lipid Panel', record_date: Date.today - 20, notes: 'Cholesterol levels slightly high, consider dietary adjustments' },
  { record_type: 'Complete Blood Count', record_date: Date.today - 30, notes: 'Within normal limits' },
  { record_type: 'Thyroid Panel', record_date: Date.today - 40, notes: 'Thyroid function normal' },
  { record_type: 'Basic Metabolic Panel', record_date: Date.today - 10, notes: 'Normal range, no issues detected.' },
  { record_type: 'Lipid Panel', record_date: Date.today - 20, notes: 'Cholesterol levels slightly high, dietary adjustments recommended.' },
  { record_type: "Doctor's Note", record_date: Date.today - 5, notes: "Patient recovering well from minor surgery. Follow-up appointment in 2 weeks." },
  { record_type: 'Appointment Reminder', record_date: Date.today + 7, notes: 'Upcoming appointment for routine check-up. Please arrive 15 minutes early.' },
  { record_type: 'Echocardiogram', record_date: Date.today - 15, notes: 'Heart function normal, no abnormalities detected.' },
  { record_type: 'MRI Scan', record_date: Date.today - 25, notes: 'No signs of issues, brain structure normal.' },
  { record_type: 'Allergy Testing', record_date: Date.today - 35, notes: 'Mild reactions to certain pollens, otherwise normal.' },
  { record_type: 'Vaccination Record', record_date: Date.today - 45, notes: 'Up to date on all vaccinations including COVID-19 booster.' }
  ]


  # Creating predefined users
  users = predefined_users.map do |user_params|
    User.create!(user_params)
  end

  users.each do |user|
    sample_posts.each do |post_params|
      post = user.posts.create!(post_params) # Posts are now directly associated with the user

      # Randomly assign other users to comment on the post
      3.times do
        commenter = users.sample # Randomly pick a user from the predefined list
        post.comments.create!(body: sample_comments.sample[:body], author: commenter)
      end

       # Randomly assign approvals to the post
       2.times do
        voter = users.sample # Randomly pick a user from the predefined list
        # Ensure the voter is not the author of the post
        next if voter == user || Approval.exists?(voter: voter, post: post)
      post.approvals.create!(votetype: sample_approvals.sample, voter: voter)
      end
    end
  end

# Add this block after creating posts, comments, and approvals

alice = users.detect { |user| user.email == "alice@example.com" }
bob = users.detect { |user| user.email == "bob@example.com" }
# Previously, you were creating new posts with generic titles like "Post 1 by Alice"
# Let's use the sample_posts content instead

if alice && bob
  # Create sample medical records for Alice as before
  sample_medical_records.each_with_index do |record, index|
    MedicalRecord.create!(
      patient_id: alice.id,
      created_by_id: bob.id,
      record_type: record[:record_type],
      record_date: record[:record_date],
      notes: record[:notes]
    )
  end

  # Now, let's iterate over sample_posts to create posts for Alice,
  # and we'll randomly decide whether to associate each post with a medical record
  sample_posts.each do |sample_post|
    post = alice.posts.create!(sample_post)

    # Randomly decide whether to associate this post with a medical record
    if [true, false].sample && alice.medical_records_as_patient.any?
      post.update(medical_record: alice.medical_records_as_patient.sample)
    end

    # Now, create comments and approvals for this post as before
    3.times do
      commenter = users.sample
      post.comments.create!(body: sample_comments.sample[:body], author: commenter)
    end

    2.times do
      voter = users.sample
      next if voter == alice || Approval.exists?(voter: voter, post: post)
      post.approvals.create!(votetype: sample_approvals.sample, voter: voter)
    end
  end
end
  ending = Time.now
  puts "It took #{(ending - starting).to_i} seconds to create sample data."
  puts "There are now #{User.count} users, #{Post.count} posts, #{Comment.count} comments, #{Approval.count} approvals, and #{MedicalRecord.count} medical records."
end
