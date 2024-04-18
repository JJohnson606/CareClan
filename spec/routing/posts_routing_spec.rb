# == Schema Information
#
# Table name: posts
#
#  id                      :uuid             not null, primary key
#  author_id               :uuid
#  body                    :text
#  image                   :string
#  trusted                 :boolean
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  approvals_count         :integer          default(0), not null
#  medical_record_id       :uuid
#  cached_votes_total      :integer          default(0)
#  cached_votes_score      :integer          default(0)
#  cached_votes_up         :integer          default(0)
#  cached_votes_down       :integer          default(0)
#  cached_weighted_score   :integer          default(0)
#  cached_weighted_total   :integer          default(0)
#  cached_weighted_average :float            default(0.0)
#  title                   :string
#  comments_count          :integer          default(0), not null
#
require "rails_helper"

RSpec.describe PostsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/posts").to route_to("posts#index")
    end

    it "routes to #new" do
      expect(get: "/posts/new").to route_to("posts#new")
    end

    it "routes to #show" do
      expect(get: "/posts/1").to route_to("posts#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/posts/1/edit").to route_to("posts#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/posts").to route_to("posts#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/posts/1").to route_to("posts#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/posts/1").to route_to("posts#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/posts/1").to route_to("posts#destroy", id: "1")
    end
  end
end
