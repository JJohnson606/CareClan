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
    20.times do
      record_type = MedicalRecord.record_types.keys.sample
      record_date = Faker::Date.between(from: 2.years.ago, to: Date.today)
      notes = ""

      case record_type
      when 'diagnosis'
        conditions = ["Common Cold", "Influenza", "Strep Throat", "Pneumonia", "Bronchitis"]
        notes = {
          condition: conditions.sample,
          symptoms: Faker::Lorem.words(number: 4).join(', '),
          recommended_treatment: Faker::Lorem.sentence
        }.to_json
      
      when 'treatment_plan'
        treatments = ["Physical therapy sessions", "Adjustment of medication regimen", "Dietary changes", "Scheduled surgery"]
        notes = {
          treatment: treatments.sample,
          duration: "#{rand(1..6)} weeks",
          follow_up: Faker::Lorem.sentence
        }.to_json
      
      when 'prescription'
        medications = ["Amoxicillin", "Ibuprofen", "Paracetamol"]
        notes = {
          medication_name: medications.sample,
          dosage: "#{rand(1..3)} times a day",
          duration: "#{rand(5..14)} days",
          purpose: Faker::Lorem.sentence
        }.to_json
      
      when 'lab_results'
        # Define test types and possible result ranges
        test_results = {
          "CBC" => {
            "WBC Count" => (4000..11000),
            "RBC Count" => (4.5..6.0),
            "Platelet Count" => (150000..450000)
          },
          "Lipid Panel" => {
            "Total Cholesterol" => (125..240),
            "HDL" => (40..60),
            "LDL" => (60..160),
            "Triglycerides" => (100..200)
          },
          "Liver Function Tests" => {
            "ALT" => (7..56),
            "AST" => (10..40),
            "ALP" => (44..147),
            "Bilirubin" => (0.1..1.2)
          },
          "Comprehensive Metabolic Panel" => {
            "Glucose" => (70..100),
            "Calcium" => (8.5..10.2),
            "Albumin" => (3.4..5.4),
            "Total Protein" => (6.0..8.3),
            "Sodium" => (135..145),
            "Potassium" => (3.5..5.1),
            "CO2" => (23..29),
            "Chloride" => (96..106),
            "ALT" => (7..56),
            "AST" => (10..40),
            "BUN" => (7..20),
            "Creatinine" => (0.6..1.2)
          }
        }
        
        selected_test = test_results.keys.sample
        results = test_results[selected_test].transform_values { |range| rand(range) }
        interpretations = results.transform_values.with_index do |(key, value), index|
          # Find the corresponding range from the test_results for the current key
          range = test_results[selected_test][key]
          if range
            value < range.begin || value > range.end ? "Abnormal" : "Normal"
          else
            "Range not defined"
          end
        end
        
      
        notes = {
          test_name: selected_test,
          results: results,
          interpretations: interpretations,
          date: record_date.to_s
        }.to_json

      when 'imaging'
        imaging_types = ["X-ray", "MRI", "CT scan", "Ultrasound"]
        findings = ["No acute disease detected", "Mild joint degeneration", "Stable cardiomegaly", "Small renal cyst"]
        notes = {
          type: imaging_types.sample,
          findings: findings.sample,
          date: record_date.to_s,
          interpretation: ["Normal", "Requires follow-up"].sample
        }.to_json
      
      when 'progress_notes'
        updates = [
          "Symptoms improving with current treatment",
          "No significant change in condition",
          "Experiencing side effects from medication",
          "Condition worsening, consider alternative treatments"
        ]
        notes = updates.map { |update|
          {
            date: Faker::Date.between(from: record_date, to: Date.today).to_s,
            note: update
          }
        }.to_json
      
      
      when 'surgical_reports'
        procedures = ["Appendectomy", "Cholecystectomy", "Total knee replacement", "Coronary artery bypass grafting"]
        outcomes = ["Procedure successful, patient recovering well", "Complications encountered, monitoring closely", "Unremarkable post-operative course", "Patient discharged with follow-up care instructions"]
        notes = {
          procedure: procedures.sample,
          date: record_date.to_s,
          findings: Faker::Lorem.sentence(word_count: 6),
          outcome: outcomes.sample
        }.to_json
      
      when 'vaccination_records'
        vaccines = ["Influenza", "Tetanus booster", "Pneumococcal", "COVID-19"]
        notes = {
          vaccine: vaccines.sample,
          date: record_date.to_s,
          lot_number: Faker::Number.number(digits: 5).to_s,
          site: ["Left arm", "Right arm"].sample
        }.to_json
      
      end

      record = MedicalRecord.create!(
        record_type: record_type,
        record_date: record_date,
        notes: notes,
        patient_id: patient.id,
        created_by_id: bob.id
      )
      puts "Medical record #{record.id} (#{record.record_type}) created for patient #{patient.name}."

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
