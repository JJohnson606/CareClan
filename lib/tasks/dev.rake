# task sample_data: :environment do
#   starting = Time.now  # Start timing the task execution

#   # Clear out existing data from all tables to start fresh
#   MedicalRecord.delete_all
#   Comment.delete_all
#   Post.delete_all
#   User.delete_all
  
#   ActsAsVotable::Vote.delete_all #Delete Votes Table
#     puts "Cleared all votes." 

#     puts 'Creating family and friends users...'
#   # Predefine some users for specific roles within the application
#   alice = User.create!(email: "alice@example.com", password: "password", name: "Alice Smith", role: 0, trust: true, profile_picture: "Alice.jpeg")  # Patient
#   bob = User.create!(email: "bob@example.com", password: "password", name: "Bob Smith", role: 1, trust: true, profile_picture: "Bob.jpeg")  # Healthcare professional
#    puts "Creating Additional Users"
#   # Create a set of family and friends users for further interaction
#   family_and_friends = [
#     { email: "carol@example.com", password: "password", name: "Carol Smith", role: 2, trust: false, profile_picture: "Carol.jpeg" },  # POA family member
#     { email: "doug@example.com", password: "password", name: "Doug Smith", role: 2, trust: true, profile_picture: "Doug.jpeg" },  # Non-POA family member
#     { email: "emily@example.com", password: "password", name: "Emily Johnson", role: 3, trust: false, profile_picture: "https://robohash.org/#{rand(9999)}" },
#     { email: "frank@example.com", password: "password", name: "Frank Brown", role: 3, trust: true, profile_picture: "https://robohash.org/#{rand(9999)}" },
#     { email: "grace@example.com", password: "password", name: "Grace Davis", role: 2, trust: false, profile_picture: "https://robohash.org/#{rand(9999)}" },
#     { email: "harry@example.com", password: "password", name: "Harry Wilson", role: 3, trust: true, profile_picture: "https://robohash.org/#{rand(9999)}" }
#   ].map { |u| User.create!(u) }  # Create and collect these user records
  
  
#   valid_family_and_friends = family_and_friends.select(&:persisted?)
#   puts "#{valid_family_and_friends.size} valid family and friends users created."

#  puts "Giving users names"
#   # Ensure that each user has a name
# User.all.each do |user|
#   user.update(name: Faker::Name.name) unless user.name.present?
# end

#   # Generate a number of additional users with random attributes using Faker

  
#   # Generate medical records for patients, created by the healthcare professional
#   User.where(role: :patient).each do |patient|
#     5.times do
#       MedicalRecord.create!(
#         record_type: Faker::Lorem.word,  # Random medical record type
#         record_date: Faker::Date.between(from: 2.years.ago, to: Date.today),  # Random date within the last 2 years
#         notes: Faker::Lorem.sentence(word_count: 20),  # Random medical notes
#         patient_id: patient.id,
#         created_by_id: bob.id  # Doctor Bob is set as the creator of all medical records
#       )
#     end
#   end

#   # Generate posts for each medical record to simulate sharing updates
#   MedicalRecord.all.each do |record|
#     post = Post.create!(
#       body: Faker::Lorem.sentence(word_count: 12),  # Random post content
#       author_id: record.patient_id,  # Author is the patient
#       medical_record_id: record.id  # Associate post with the medical record
#     )

#     # For each post, generate comments from family and friends
#     family_and_friends.each do |family_member|
#       Comment.create!(
#         body: Faker::Lorem.sentence(word_count: 8),  # Random comment content
#         author_id: family_member.id,
#         post_id: post.id  # Associate comment with the post
#       )
#     end

   
#   # For each post, also generate upvotes and downvotes from family and friends
  
# end

# Post.find_each do |post|
#   family_and_friends.each do |family_member|
#     next unless User.exists?(family_member.id)
#     next if post.voted_on_by?(family_member)

#     vote_type = [true, false].sample
#     if vote_type
#       post.liked_by family_member
#       puts "#{family_member.name} approved post #{post.id}" if post.vote_registered?
#     else
#       post.disliked_by family_member
#       puts "#{family_member.name} disapproved post #{post.id}" if post.vote_registered?
#     end
#   rescue StandardError => e
#     puts "An error occurred when #{family_member.name} tried to vote on post #{post.id}: #{e.message}"
#   end
# end  # This end closes the Post.find_each block


#   ending = Time.now
#   total_votes = Post.sum { |post| post.get_likes.size + post.get_dislikes.size }
#   puts "It took #{(ending - starting).to_i} seconds to create sample data."
#   puts "There are now #{User.count} users, #{Post.count} posts, #{Comment.count} comments, #{total_votes} votes, and #{MedicalRecord.count} medical records."
# end







task sample_data: :environment do
  starting = Time.now

  # Clear out existing data
  MedicalRecord.delete_all
  Comment.delete_all
  Post.delete_all
  User.delete_all
  ActsAsVotable::Vote.delete_all
  puts "Cleared all existing data."

  # Create predefined users
  alice = User.create!(email: "alice@example.com", password: "password", name: "Alice Smith", role: 0, trust: true, profile_picture: "Alice.jpeg")
  bob = User.create!(email: "bob@example.com", password: "password", name: "Bob Smith", role: 1, trust: true, profile_picture: "Bob.jpeg")
  puts "Predefined users Alice and Bob created."

  # Create family and friends users
  family_and_friends = [
    { email: "carol@example.com", password: "password", name: "Carol Smith", role: 2, trust: false, profile_picture: "Carol.jpeg" },  # POA family member
    { email: "doug@example.com", password: "password", name: "Doug Smith", role: 2, trust: true, profile_picture: "Doug.jpeg" },  # Non-POA family member
    { email: "emily@example.com", password: "password", name: "Emily Johnson", role: 3, trust: false, profile_picture: "https://robohash.org/#{rand(9999)}" },
    { email: "frank@example.com", password: "password", name: "Frank Brown", role: 3, trust: true, profile_picture: "https://robohash.org/#{rand(9999)}" },
    { email: "grace@example.com", password: "password", name: "Grace Davis", role: 2, trust: false, profile_picture: "https://robohash.org/#{rand(9999)}" },
    { email: "harry@example.com", password: "password", name: "Harry Wilson", role: 3, trust: true, profile_picture: "https://robohash.org/#{rand(9999)}" }
    # Family and friends data...
  ].map { |u| User.create!(u) }

  valid_family_and_friends = family_and_friends.select(&:persisted?)
  puts "#{valid_family_and_friends.size} valid family and friends users created."

  # Generate medical records and posts
  User.where(role: :patient).each do |patient|
    5.times do
      record = MedicalRecord.create!(
        record_type: Faker::Lorem.word,  # Random medical record type
                record_date: Faker::Date.between(from: 2.years.ago, to: Date.today),  # Random date within the last 2 years
                notes: Faker::Lorem.sentence(word_count: 20),  # Random medical notes
                patient_id: patient.id,
                created_by_id: bob.id  # Doctor Bob is set as the creator of all medical records
      )
      puts "Medical record #{record.id} created for patient #{patient.name}."

      post = Post.create!(
        body: Faker::Lorem.sentence(word_count: 12),
        author_id: patient.id,
        medical_record_id: record.id
      )
      puts "Post #{post.id} created linked to medical record #{record.id}."

      valid_family_and_friends.each do |family_member|
        Comment.create!(
          body: Faker::Lorem.sentence(word_count: 8),
          author_id: family_member.id,
          post_id: post.id
        )
        puts "#{family_member.name} commented on post #{post.id}."
      end
    end
  end

  # Generate votes
  Post.find_each do |post|
    valid_family_and_friends.each do |family_member|
      next if post.voted_on_by?(family_member)

      vote_type = [true, false].sample
      action = vote_type ? :likes : :dislikes

      family_member.send(action, post)
      puts "#{family_member.name} #{vote_type ? 'approved' : 'disapproved'} post #{post.id}." if post.vote_registered?
    end
  rescue StandardError => e
    puts "An error occurred for family_member #{family_member.name} on post #{post.id}: #{e.message}"
  end

  ending = Time.now
  puts "Sample data creation completed in #{ending - starting} seconds."
  puts "Summary: #{User.count} users, #{Post.count} posts, #{Comment.count} comments, #{ActsAsVotable::Vote.count} votes, #{MedicalRecord.count} medical records."
end
