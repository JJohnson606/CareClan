# lib/tasks/dev.rake
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
  alice = User.create!(email: "alice@example.com", password: "password", name: "Alice Smith", role: 3, trust: true, profile_picture: "Alice.jpeg")
  bob = User.create!(email: "bob@example.com", password: "password", name: "Bob Smith", role: 1, trust: true, profile_picture: "Bob.jpeg")
  gary = User.create!(email: "gary@example.com", password: "password", name: "Gary Nixon", role: 0, trust: true, profile_picture: "Gary.jpeg")
  puts "Predefined users Alice, Gary, and Bob created."

  doctors = [
    { email: "radiologist@example.com", password: "password", name: "Dr. Ray Scan", role: 1, profile_picture: "Ray.jpeg" },
    { email: "orthopedist@example.com", password: "password", name: "Dr. Jane Setter", role: 1, profile_picture: "Jane.jpeg" },
    { email: "gp@example.com", password: "password", name: "Dr. Samuel Green", role: 1, profile_picture: "Samuel.jpeg" },
    { email: "therapist@example.com", password: "password", name: "Dr. Alma Chavez", role: 1, profile_picture: "Alma.jpeg" }
  ].map { |u| User.create!(u) }
  puts "Doctor users created."

  # Create family and friends users
  family_and_friends = [
    { email: "carol@example.com", password: "password", name: "Carol Smith", role: 2, trust: false, profile_picture: "Carol.jpeg" },  # POA family member
    { email: "doug@example.com", password: "password", name: "Doug Smith", role: 2, trust: true, profile_picture: "Doug.jpeg" },  # Non-POA family member
    { email: "emily@example.com", password: "password", name: "Emily Johnson", role: 3, trust: false, profile_picture: "Emily.jpeg" },
    { email: "frank@example.com", password: "password", name: "Frank Brown", role: 3, trust: true, profile_picture: "Frank.jpeg" },
    { email: "grace@example.com", password: "password", name: "Grace Davis", role: 2, trust: false, profile_picture: "Grace.jpeg" },
    { email: "harry@example.com", password: "password", name: "Harry Wilson", role: 3, trust: true, profile_picture: "Harry.jpeg" },
    { email: "irene@example.com", password: "password", name: "Irene Morgan", role: 2, trust: false, profile_picture: "Irene.jpeg" },
    { email: "jack@example.com", password: "password", name: "Jack Lee", role: 3, trust: true, profile_picture: "Jack.jpeg" },
    { email: "kelly@example.com", password: "password", name: "Kelly Young", role: 3, trust: false, profile_picture: "Kelly.jpeg" },
    { email: "liam@example.com", password: "password", name: "Liam Davis", role: 2, trust: true, profile_picture: "Liam.jpeg" }
    # Family and friends data...
  ].map { |u| User.create!(u) }

  valid_family_and_friends = family_and_friends.select(&:persisted?)
  puts "#{valid_family_and_friends.size} valid family and friends users created."

  xray = MedicalRecord.create!(
    record_type: 'imaging',
    record_date: Date.today - 30.day,
    notes: { type: "X-ray", findings: "The X-ray image reveals a clear fracture in the metacarpal bone. 
       This includes a transverse fracture of the fourth metacarpal, which is characterized by a break that extends horizontally across the bone shaft.
       The fracture line is sharp and well-defined, indicating a recent and acute injury. 
       There is slight displacement and angulation of the fracture fragments, suggesting that some movement of the bone fragments has occurred since the injury. No other bone abnormalities or associated injuries,
       such as additional fractures or dislocations in adjacent bones, are visible. Soft tissue swelling is noted around the fracture site, which is consistent with trauma.",
       interpretation: "The radiographic findings confirm the clinical suspicion of a metacarpal fracture. 
       The nature of the fracture—transverse with slight displacement—suggests that significant force was applied across the metacarpal, 
       typical of direct trauma or an impact injury. Given the displacement, orthopedic consultation is recommended for possible reduction,
       where the bone fragments will be realigned. This is crucial to ensure proper healing and to restore the normal anatomical structure of the hand,
       thereby preventing future complications such as malunion (improper healing leading to deformity) or impaired hand function." }.to_json,
    patient_id: gary.id,
    created_by_id: doctors[0].id
  )
  
  diagnosis = MedicalRecord.create!(
    record_type: 'diagnosis',
    record_date: Date.today - 30.day,
    notes: { condition: "Fractured Hand", symptoms: "Pain and swelling", recommended_treatment: "Orthopedic consultation and casting" }.to_json,
    patient_id: gary.id,
    created_by_id: doctors[1].id
  )
  
  # Step 2: Treatment plan and prescription
  treatment_plan = MedicalRecord.create!(
    record_type: 'treatment_plan',
    record_date: Date.today - 23.day,
    notes: { treatment: "Casting and pain management", duration: "6 weeks", follow_up: "Regular check-ups and potential physical therapy" }.to_json,
    patient_id: gary.id,
    created_by_id: doctors[1].id
  )
  
  prescription = MedicalRecord.create!(
    record_type: 'prescription',
    record_date: Date.today - 23.day,
    notes: { medication_name: "Ibuprofen", dosage: "400 mg every 8 hours", duration: "2 weeks", purpose: "Manage pain and inflammation" }.to_json,
    patient_id: gary.id,
    created_by_id: doctors[2].id
  )
  
  # Step 3: Follow-up and rehabilitation
  physical_therapy = MedicalRecord.create!(
    record_type: 'treatment_plan',
    record_date: Date.today + 42.days,
    notes: { treatment: "Physical Therapy", duration: "4 weeks", follow_up: "Re-assess functional recovery" }.to_json,
    patient_id: gary.id,
    created_by_id: doctors[3].id
  )
  

  # Generate medical records and posts
  User.where(role: :patient).each do |patient|
    10.times do
      record_type = MedicalRecord.record_types.keys.sample
      record_date = Faker::Date.between(from: 2.years.ago, to: Date.today - 14.days)
      notes = ""
      title = Faker::Lorem.sentence(word_count: 3) 

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
            "WBC Count" => { normal: (4000..11000), optimal: (5000..10000), clinical: (2000..17000) },
            "RBC Count" => { normal: (4.5..6.0), optimal: (4.7..5.7), clinical: (3.8..6.5) },
            "Hemoglobin" => { normal: (12..18), optimal: (13..17), clinical: (10..20) },
            "Hematocrit" => { normal: (37..52), optimal: (40..50), clinical: (30..60) },
            "Platelet Count" => { normal: (150000..450000), optimal: (180000..400000), clinical: (100000..500000) }
          },
          "Lipid Panel" => {
            "Total Cholesterol" => { normal: (125..240), optimal: (130..200), clinical: (100..300) },
            "HDL" => { normal: (40..60), optimal: (45..65), clinical: (35..75) },
            "LDL" => { normal: (60..160), optimal: (70..130), clinical: (50..190) },
            "Triglycerides" => { normal: (100..200), optimal: (90..150), clinical: (80..220) }
          },
          "Liver Function Tests" => {
            "ALT" => { normal: (7..56), optimal: (10..40), clinical: (5..100) },
            "AST" => { normal: (10..40), optimal: (15..35), clinical: (8..80) },
            "ALP" => { normal: (44..147), optimal: (50..130), clinical: (30..200) },
            "Bilirubin" => { normal: (0.1..1.2), optimal: (0.2..1.0), clinical: (0.0..2.0) }
          },
          "Comprehensive Metabolic Panel" => {
            "Glucose" => { normal: (70..100), optimal: (75..95), clinical: (60..110) },
            "Calcium" => { normal: (8.5..10.2), optimal: (8.7..9.9), clinical: (8.0..10.5) },
            "Albumin" => { normal: (3.4..5.4), optimal: (3.8..5.0), clinical: (3.0..6.0) },
            "Total Protein" => { normal: (6.0..8.3), optimal: (6.4..8.0), clinical: (5.5..8.5) },
            "Sodium" => { normal: (135..145), optimal: (137..143), clinical: (130..150) },
            "Potassium" => { normal: (3.5..5.1), optimal: (3.7..4.8), clinical: (3.0..5.5) },
            "CO2" => { normal: (23..29), optimal: (24..28), clinical: (20..32) },
            "Chloride" => { normal: (96..106), optimal: (98..104), clinical: (90..110) },
            "BUN" => { normal: (7..20), optimal: (8..18), clinical: (5..25) },
            "Creatinine" => { normal: (0.6..1.2), optimal: (0.7..1.1), clinical: (0.5..1.5) }
          },
          "Thyroid Tests" => {
            "TSH" => { normal: (0.5..5.0), optimal: (0.8..2.5), clinical: (0.3..10.0) },
            "Free T4" => { normal: (0.9..1.7), optimal: (1.0..1.5), clinical: (0.8..2.0) }
          },
          "Coagulation Panel" => {
            "PT" => { normal: (9.5..13.5), optimal: (10..12), clinical: (9..15) },
            "INR" => { normal: (0.8..1.2), optimal: (0.9..1.1), clinical: (0.5..1.5) },
            "PTT" => { normal: (25..35), optimal: (26..34), clinical: (20..40) }
          }      
        }

        selected_test = test_results.keys.sample
        results = {}
        
        test_results[selected_test].each do |test, ranges|
          normal_range = ranges[:normal]
          clinical_range = ranges[:clinical] || normal_range
        
          mean = (normal_range.begin + normal_range.end) / 2.0
          sd = (normal_range.end - mean) / 2  # Assuming this is a simplified standard deviation calculation
        
          # Round the start and end points of the optimal range to integers
          optimal_range_start = (mean - sd).round
          optimal_range_end = (mean + sd).round
        
          # Create the optimal range with rounded values
          optimal_range = (optimal_range_start..optimal_range_end)
        
          value = rand(normal_range)  # Ensure this uses integer values
        
          results[test] = {
            value: value,
            clinical_range: [clinical_range.begin.to_i, clinical_range.end.to_i],  # Convert to array with integer values
            normal_range: [normal_range.begin.to_i, normal_range.end.to_i],        # Convert to array with integer values
            optimal_range: [optimal_range_start, optimal_range_end]                # Already integers from rounding
          }
        end
        
        notes = {
          test_name: selected_test,
          results: results.transform_values { |result| result[:value] },
          ranges: results.transform_values { |result| result.except(:value) },
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
        title: title,
        body: Faker::Lorem.sentence(word_count: 12),
        author_id: patient.id,
        medical_record_id: record.id
      )
      puts "Post #{post.id} created linked to medical record #{record.id}."
# Generate primary comments

  # Recursive method to generate nested comments
  def generate_nested_comments(commenter, post, parent_id = nil, depth = 0, max_depth = 5)
    return if depth >= max_depth

    num_comments = rand(1..8) # Each comment can have 1 to 3 replies
    num_comments.times do
      comment = Comment.create!(
        body: Faker::Lorem.sentence(word_count: rand(5..30)),
        author: commenter.sample,
        post: post,
        parent_id: parent_id
      )
      puts "#{comment.author.name} commented on post #{post.id}, depth #{depth + 1}"

      # Recursively create replies to the current comment
      if rand > 0.3 # 70% chance to continue creating deeper comments
        generate_nested_comments(commenter, post, comment.id, depth + 1, max_depth)
      end
    end
  end
  5.times do |i|
    commenter = valid_family_and_friends.sample
    comment = Comment.create!(
      body: Faker::Lorem.sentence(word_count: 40),
      author_id: commenter.id,
      post_id: post.id
    )
    puts "#{commenter.name} commented on post #{post.id}."

    # Generate nested reply comments up to 10 levels deep
    depth = 0
    while depth < 10 && [true, false].sample
      reply_commenter = valid_family_and_friends.sample
      comment = Comment.create!(
        body: Faker::Lorem.sentence(word_count: 30),
        author_id: reply_commenter.id,
        post_id: post.id,
        parent_id: comment.id
      )
      puts "#{reply_commenter.name} replied to comment #{comment.id} on post #{post.id}."
      depth += 1
    end
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

Comment.find_each do |comment|
  valid_family_and_friends.each do |family_member|
    next if comment.voted_on_by?(family_member)

    vote_type = [true, false].sample
    action = vote_type ? :likes : :dislikes

    family_member.send(action, comment)
    puts "#{family_member.name} #{vote_type ? 'approved' : 'disapproved'} comment #{comment.id}." if comment.vote_registered?
  end
end

ending = Time.now
puts "Sample data creation completed in #{(ending - starting).round(2)} seconds."
puts "Summary: #{User.count} users, #{Post.count} posts, #{Comment.count} comments, #{ActsAsVotable::Vote.count} votes, #{MedicalRecord.count} medical records."
end
