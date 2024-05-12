# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_240_502_204_709) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'pgcrypto'
  enable_extension 'plpgsql'

  create_table 'active_storage_attachments', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'name', null: false
    t.string 'record_type', null: false
    t.uuid 'record_id', null: false
    t.uuid 'blob_id', null: false
    t.datetime 'created_at', null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness',
                                                    unique: true
  end

  create_table 'active_storage_blobs', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'key', null: false
    t.string 'filename', null: false
    t.string 'content_type'
    t.text 'metadata'
    t.string 'service_name', null: false
    t.bigint 'byte_size', null: false
    t.string 'checksum'
    t.datetime 'created_at', null: false
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'active_storage_variant_records', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.uuid 'blob_id', null: false
    t.string 'variation_digest', null: false
    t.index %w[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
  end

  create_table 'approvals', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.boolean 'votetype'
    t.uuid 'voter_id', null: false
    t.uuid 'post_id', null: false
    t.integer 'approvals_count', default: 0
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['post_id'], name: 'index_approvals_on_post_id'
    t.index %w[voter_id post_id], name: 'index_approvals_on_voter_id_and_post_id', unique: true
    t.index ['voter_id'], name: 'index_approvals_on_voter_id'
  end

  create_table 'clan_memberships', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.uuid 'clan_id', null: false
    t.uuid 'user_id', null: false
    t.string 'role', default: 'member', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['clan_id'], name: 'index_clan_memberships_on_clan_id'
    t.index ['user_id'], name: 'index_clan_memberships_on_user_id'
  end

  create_table 'clans', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'name', null: false
    t.text 'description'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['name'], name: 'index_clans_on_name', unique: true
  end

  create_table 'comments', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.text 'body'
    t.uuid 'post_id', null: false
    t.uuid 'author_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.uuid 'parent_id'
    t.integer 'replies_count', default: 0, null: false
    t.integer 'cached_votes_total', default: 0, null: false
    t.integer 'cached_votes_score', default: 0, null: false
    t.integer 'cached_votes_up', default: 0, null: false
    t.integer 'cached_votes_down', default: 0, null: false
    t.integer 'cached_weighted_score', default: 0, null: false
    t.integer 'cached_weighted_total', default: 0, null: false
    t.float 'cached_weighted_average', default: 0.0, null: false
    t.integer 'cached_vote_diff', default: 0
    t.integer 'votes_count', default: 0, null: false
    t.index ['author_id'], name: 'index_comments_on_author_id'
    t.index ['parent_id'], name: 'index_comments_on_parent_id'
    t.index ['post_id'], name: 'index_comments_on_post_id'
  end

  create_table 'good_job_batches', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.text 'description'
    t.jsonb 'serialized_properties'
    t.text 'on_finish'
    t.text 'on_success'
    t.text 'on_discard'
    t.text 'callback_queue_name'
    t.integer 'callback_priority'
    t.datetime 'enqueued_at'
    t.datetime 'discarded_at'
    t.datetime 'finished_at'
  end

  create_table 'good_job_executions', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.uuid 'active_job_id', null: false
    t.text 'job_class'
    t.text 'queue_name'
    t.jsonb 'serialized_params'
    t.datetime 'scheduled_at'
    t.datetime 'finished_at'
    t.text 'error'
    t.integer 'error_event', limit: 2
    t.text 'error_backtrace', array: true
    t.index %w[active_job_id created_at], name: 'index_good_job_executions_on_active_job_id_and_created_at'
  end

  create_table 'good_job_processes', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.jsonb 'state'
  end

  create_table 'good_job_settings', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.text 'key'
    t.jsonb 'value'
    t.index ['key'], name: 'index_good_job_settings_on_key', unique: true
  end

  create_table 'good_jobs', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.text 'queue_name'
    t.integer 'priority'
    t.jsonb 'serialized_params'
    t.datetime 'scheduled_at'
    t.datetime 'performed_at'
    t.datetime 'finished_at'
    t.text 'error'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.uuid 'active_job_id'
    t.text 'concurrency_key'
    t.text 'cron_key'
    t.uuid 'retried_good_job_id'
    t.datetime 'cron_at'
    t.uuid 'batch_id'
    t.uuid 'batch_callback_id'
    t.boolean 'is_discrete'
    t.integer 'executions_count'
    t.text 'job_class'
    t.integer 'error_event', limit: 2
    t.text 'labels', array: true
    t.index %w[active_job_id created_at], name: 'index_good_jobs_on_active_job_id_and_created_at'
    t.index ['batch_callback_id'], name: 'index_good_jobs_on_batch_callback_id',
                                   where: '(batch_callback_id IS NOT NULL)'
    t.index ['batch_id'], name: 'index_good_jobs_on_batch_id', where: '(batch_id IS NOT NULL)'
    t.index ['concurrency_key'], name: 'index_good_jobs_on_concurrency_key_when_unfinished',
                                 where: '(finished_at IS NULL)'
    t.index %w[cron_key created_at], name: 'index_good_jobs_on_cron_key_and_created_at_cond',
                                     where: '(cron_key IS NOT NULL)'
    t.index %w[cron_key cron_at], name: 'index_good_jobs_on_cron_key_and_cron_at_cond', unique: true,
                                  where: '(cron_key IS NOT NULL)'
    t.index ['finished_at'], name: 'index_good_jobs_jobs_on_finished_at',
                             where: '((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))'
    t.index ['labels'], name: 'index_good_jobs_on_labels', where: '(labels IS NOT NULL)', using: :gin
    t.index %w[priority created_at], name: 'index_good_job_jobs_for_candidate_lookup', where: '(finished_at IS NULL)'
    t.index %w[priority created_at], name: 'index_good_jobs_jobs_on_priority_created_at_when_unfinished',
                                     order: { priority: 'DESC NULLS LAST' }, where: '(finished_at IS NULL)'
    t.index %w[queue_name scheduled_at], name: 'index_good_jobs_on_queue_name_and_scheduled_at',
                                         where: '(finished_at IS NULL)'
    t.index ['scheduled_at'], name: 'index_good_jobs_on_scheduled_at', where: '(finished_at IS NULL)'
  end

  create_table 'medical_records', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.uuid 'patient_id', null: false
    t.string 'record_type'
    t.date 'record_date'
    t.text 'notes'
    t.uuid 'created_by_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['created_by_id'], name: 'index_medical_records_on_created_by_id'
    t.index ['patient_id'], name: 'index_medical_records_on_patient_id'
  end

  create_table 'noticed_events', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'type'
    t.string 'record_type'
    t.uuid 'record_id'
    t.jsonb 'params'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'notifications_count'
    t.index %w[record_type record_id], name: 'index_noticed_events_on_record'
  end

  create_table 'noticed_notifications', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'type'
    t.uuid 'event_id', null: false
    t.string 'recipient_type', null: false
    t.uuid 'recipient_id', null: false
    t.datetime 'read_at', precision: nil
    t.datetime 'seen_at', precision: nil
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['event_id'], name: 'index_noticed_notifications_on_event_id'
    t.index %w[recipient_type recipient_id], name: 'index_noticed_notifications_on_recipient'
  end

  create_table 'posts', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.uuid 'author_id'
    t.text 'body'
    t.string 'image'
    t.boolean 'trusted'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'approvals_count', default: 0, null: false
    t.uuid 'medical_record_id'
    t.integer 'cached_votes_total', default: 0
    t.integer 'cached_votes_score', default: 0
    t.integer 'cached_votes_up', default: 0
    t.integer 'cached_votes_down', default: 0
    t.integer 'cached_weighted_score', default: 0
    t.integer 'cached_weighted_total', default: 0
    t.float 'cached_weighted_average', default: 0.0
    t.string 'title'
    t.integer 'cached_vote_diff', default: 0
    t.integer 'comments_count', default: 0, null: false
    t.index ['author_id'], name: 'index_posts_on_author_id'
    t.index ['title'], name: 'index_posts_on_title'
  end

  create_table 'users', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'role'
    t.boolean 'trust'
    t.string 'name'
    t.string 'relationship_to_patient'
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  create_table 'votes', force: :cascade do |t|
    t.string 'votable_type'
    t.string 'voter_type'
    t.boolean 'vote_flag'
    t.string 'vote_scope'
    t.integer 'vote_weight'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.uuid 'votable_id'
    t.uuid 'voter_id'
    t.index %w[votable_id votable_type vote_scope], name: 'index_votes_on_votable_and_scope'
    t.index %w[voter_id voter_type vote_scope], name: 'index_votes_on_voter_and_scope'
  end

  add_foreign_key 'active_storage_attachments', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'active_storage_variant_records', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'approvals', 'posts'
  add_foreign_key 'approvals', 'users', column: 'voter_id'
  add_foreign_key 'clan_memberships', 'clans'
  add_foreign_key 'clan_memberships', 'users'
  add_foreign_key 'comments', 'posts'
  add_foreign_key 'comments', 'users', column: 'author_id'
  add_foreign_key 'medical_records', 'users', column: 'created_by_id'
  add_foreign_key 'medical_records', 'users', column: 'patient_id'
  add_foreign_key 'noticed_notifications', 'noticed_events', column: 'event_id'
  add_foreign_key 'posts', 'users', column: 'author_id'
end
