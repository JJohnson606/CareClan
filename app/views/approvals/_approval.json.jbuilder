json.extract! approval, :id, :votetype, :voter_id, :post_id, :approvals_count, :created_at, :updated_at
json.url approval_url(approval, format: :json)
