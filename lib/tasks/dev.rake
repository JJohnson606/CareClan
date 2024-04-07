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
          },
          "Urinalysis" => {
          "Color" => ["Yellow", "Amber", "Straw"],
          "Appearance" => ["Clear", "Cloudy", "Hazy"],
          "pH" => { normal: (4.5..8.0), optimal: (5.0..7.5), clinical: (4.0..9.0) },
          "Specific Gravity" => { normal: (1.005..1.030), optimal: (1.010..1.025), clinical: (1.000..1.035) },
          "Protein" => ["Negative", "Trace", "Positive"],
          "Glucose" => ["Negative", "Trace", "Positive"],
          "Ketones" => ["Negative", "Trace", "Positive"],
          "Leukocyte Esterase" => ["Negative", "Trace", "Positive"],
          "Nitrites" => ["Negative", "Positive"],
          "Blood" => ["Negative", "Trace", "Positive"],
          "WBCs" => { normal: (0..5), clinical: (6..20) },  
          "RBCs" => { normal: (0..2), clinical: (3..50) },  
          "Casts" => ["None", "Hyaline", "Granular", "Cellular"],
          "Crystals" => ["None", "Urates", "Oxalates", "Phosphates"],
          "Bacteria" => ["None", "Few", "Moderate", "Many"]
         }
        }
        selected_test = test_results.keys.sample
  results = {}

  test_results[selected_test].each do |test, ranges|
    unless ranges.is_a?(Hash)
      puts "Skipping test #{test} due to unexpected ranges format: #{ranges.inspect}"
      next
    end

    range_types = ranges.keys # Get all possible range types (e.g., :normal, :optimal, :clinical)
    range_type = range_types.sample # Randomly select one range type

    selected_range = ranges[range_type] # Get the selected range

    if selected_range.is_a?(Range)
      value = rand(selected_range) # Generate a random value within the selected range
    else
      puts "Expected 'selected_range' to be a Range, got #{selected_range.class} for test #{test}"
      next
    end

    results[test] = { value: value, range_type: range_type.to_s } # Store the value and its range type
  end

  interpretations = results.transform_values do |result|
    case result[:range_type]
    when 'normal'
      'Normal'
    when 'optimal'
      'Optimal'
    when 'clinical'
      'Clinical'
    else
      'Abnormal'
    end
  end

  notes = {
    test_name: selected_test,
    results: results.transform_values { |result| result[:value] }, # Only store the values in the final JSON
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
