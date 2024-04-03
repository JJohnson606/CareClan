json.extract! post, :id, :author_id, :body, :image, :trusted, :created_at, :updated_at
json.url post_url(post, format: :json)
