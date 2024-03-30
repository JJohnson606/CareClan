require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/approvals", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # Approval. As you add validations to Approval, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Approval.create! valid_attributes
      get approvals_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      approval = Approval.create! valid_attributes
      get approval_url(approval)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_approval_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      approval = Approval.create! valid_attributes
      get edit_approval_url(approval)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Approval" do
        expect {
          post approvals_url, params: { approval: valid_attributes }
        }.to change(Approval, :count).by(1)
      end

      it "redirects to the created approval" do
        post approvals_url, params: { approval: valid_attributes }
        expect(response).to redirect_to(approval_url(Approval.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Approval" do
        expect {
          post approvals_url, params: { approval: invalid_attributes }
        }.to change(Approval, :count).by(0)
      end

    
      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post approvals_url, params: { approval: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested approval" do
        approval = Approval.create! valid_attributes
        patch approval_url(approval), params: { approval: new_attributes }
        approval.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the approval" do
        approval = Approval.create! valid_attributes
        patch approval_url(approval), params: { approval: new_attributes }
        approval.reload
        expect(response).to redirect_to(approval_url(approval))
      end
    end

    context "with invalid parameters" do
    
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        approval = Approval.create! valid_attributes
        patch approval_url(approval), params: { approval: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested approval" do
      approval = Approval.create! valid_attributes
      expect {
        delete approval_url(approval)
      }.to change(Approval, :count).by(-1)
    end

    it "redirects to the approvals list" do
      approval = Approval.create! valid_attributes
      delete approval_url(approval)
      expect(response).to redirect_to(approvals_url)
    end
  end
end