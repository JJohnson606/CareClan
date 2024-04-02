desc "Fill the database tables with some sample data"
task sample_data: :environment do
  starting = Time.now  # Start timing the task execution

  # Clear out existing data from all tables to start fresh
  MedicalRecord.delete_all
  Approval.delete_all
  Comment.delete_all
  Post.delete_all
  User.delete_all

  # Predefine some users for specific roles within the application
  alice = User.create!(email: "alice@example.com", password: "password", name: "Alice Smith", role: 0, trust: true, profile_picture: "Alice.jpeg")  # Patient
  bob = User.create!(email: "bob@example.com", password: "password", name: "Bob Smith", role: 1, trust: true, profile_picture: "Bob.jpeg")  # Healthcare professional
  
  # Create a set of family and friends users for further interaction
  family_and_friends = [
    { email: "carol@example.com", password: "password", name: "Carol Smith", role: 2, trust: false, profile_picture: "Carol.jpeg" },  # POA family member
    { email: "doug@example.com", password: "password", name: "Doug Smith", role: 2, trust: true, profile_picture: "Doug.jpeg" },  # Non-POA family member
    # Additional family and friends can be added here...
  ].map { |u| User.create!(u) }  # Create and collect these user records

  # Generate a number of additional users with random attributes using Faker
  10.times do
    User.create!(
      email: Faker::Internet.unique.email,
      password: 'password',
      name: Faker::Name.name,
      role: rand(0..3),  # Random role assignment
      trust: Faker::Boolean.boolean,
      profile_picture: "https://robohash.org/#{rand(9999)}"
    )
  end

  # Generate medical records for patients, created by the healthcare professional
  User.where(role: :patient).each do |patient|
    20.times do
      MedicalRecord.create!(
        record_type: Faker::Lorem.word,  # Random medical record type
        record_date: Faker::Date.between(from: 2.years.ago, to: Date.today),  # Random date within the last 2 years
        notes: Faker::Lorem.sentence(word_count: 20),  # Random medical notes
        patient_id: patient.id,
        created_by_id: bob.id  # Doctor Bob is set as the creator of all medical records
      )
    end
  end

  # Generate posts for each medical record to simulate sharing updates
  MedicalRecord.all.each do |record|
    post = Post.create!(
      body: Faker::Lorem.sentence(word_count: 12),  # Random post content
      author_id: record.patient_id,  # Author is the patient
      medical_record_id: record.id  # Associate post with the medical record
    )

    # For each post, generate comments from family and friends
    family_and_friends.each do |family_member|
      Comment.create!(
        body: Faker::Lorem.sentence(word_count: 8),  # Random comment content
        author_id: family_member.id,
        post_id: post.id  # Associate comment with the post
      )
    end

    # For each post, also generate approval votes from family and friends
    family_and_friends.each do |family_member|
      Approval.create!(
        votetype: [true, false].sample,  # Randomly choose approval or disapproval
        voter_id: family_member.id,
        post_id: post.id  # Associate approval with the post
      )
    end
  end

  ending = Time.now
  puts "It took #{(ending - starting).to_i} seconds to create sample data."
  puts "There are now #{User.count} users, #{Post.count} posts, #{Comment.count} comments, #{Approval.count} approvals, and #{MedicalRecord.count} medical records."
end