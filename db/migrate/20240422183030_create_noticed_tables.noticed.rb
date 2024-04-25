class CreateNoticedTables < ActiveRecord::Migration[6.1]
  def change
    # Determine the key types for primary and foreign keys
    primary_key_type, foreign_key_type = primary_and_foreign_key_types

    # Create the noticed_events table with a UUID primary key
    create_table :noticed_events, id: :uuid do |t|
      t.string :type
      t.references :record, polymorphic: true, type: foreign_key_type, index: true

      # Use jsonb for params if supported, otherwise fallback to json
      if ActiveRecord::Base.connection.adapter_name.downcase.include?('postgresql')
        t.jsonb :params
      else
        t.json :params
      end

      t.timestamps
    end

    # Create the noticed_notifications table with a UUID primary key
    create_table :noticed_notifications, id: :uuid do |t|
      t.string :type
      t.references :event, type: :uuid, null: false, foreign_key: { to_table: :noticed_events }
      t.references :recipient, polymorphic: true, type: :uuid, null: false

      t.datetime :read_at
      t.datetime :seen_at

      t.timestamps
    end
  end

  private

  # This method determines the types to be used for primary and foreign keys based on the application's configuration
  def primary_and_foreign_key_types
    config = Rails.configuration.generators
    setting = config.options[config.orm][:primary_key_type]
    primary_key_type = setting || :primary_key
    foreign_key_type = setting || (primary_key_type == :uuid ? :uuid : :bigint)
    [primary_key_type, foreign_key_type]
  end
end
