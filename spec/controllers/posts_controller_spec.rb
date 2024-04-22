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
#  cached_vote_diff        :integer          default(0)
#
require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  let(:valid_attributes) {
    { title: 'Test Post', body: 'This is a test post' }
  }

  let(:invalid_attributes) {
    { title: nil, body: nil }
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      post = Post.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      post = Post.create! valid_attributes
      get :show, params: {id: post.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      post = Post.create! valid_attributes
      get :edit, params: {id: post.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Post" do
        expect {
          post :create, params: {post: valid_attributes}, session: valid_session
        }.to change(Post, :count).by(1)
      end

      it "redirects to the created post" do
        post :create, params: {post: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Post.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {post: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { title: 'Updated Post Title' }
      }

      it "updates the requested post" do
        post = Post.create! valid_attributes
        put :update, params: {id: post.to_param, post: new_attributes}, session: valid_session
        post.reload
        expect(post.title).to eq('Updated Post Title')
      end

      it "redirects to the post" do
        post = Post.create! valid_attributes
        put :update, params: {id: post.to_param, post: valid_attributes}, session: valid_session
        expect(response).to redirect_to(post)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        post = Post.create! valid_attributes
        put :update, params: {id: post.to_param, post: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested post" do
      post = Post.create! valid_attributes
      expect {
        delete :destroy, params: {id: post.to_param}, session: valid_session
      }.to change(Post, :count).by(-1)
    end

    it "redirects to the posts list" do
      post = Post.create! valid_attributes
      delete :destroy, params: {id: post.to_param}, session: valid_session
      expect(response).to redirect_to(posts_url)
    end
  end

end
