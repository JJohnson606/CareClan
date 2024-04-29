module PostLoadable
  extend ActiveSupport::Concern

  private

  def set_post
    @post = Post.find(params[:id])
    redirect_to posts_path, alert: "Post not found." unless @post
  end

  def set_medical_record
    @medical_record = MedicalRecord.find(params[:medical_record_id]) if params[:medical_record_id].present?
  end
end
