class MedicalRecordPolicy < ApplicationPolicy
  def index?
    user.present? && (user.healthcare_professional? || user.clan_poa? || user.admin? || user.patient?)
  end

  def show?
    if record.posts.any? { |post| post == @post }
      true
    else
      user.present? && (user.healthcare_professional? || user.clan_poa? || user.admin? || (user.patient? && record.patient_id == user.id))
    end
  end

  def create?
    user.present? && user.healthcare_professional?
  end

  def new?
    create?
  end

  def update?
    user.present? && user.healthcare_professional?
  end

  def edit?
    update?
  end

  def destroy?
    user.present? && user.healthcare_professional?
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all
      elsif user.healthcare_professional?
        scope.where(created_by_id: user.id)
      elsif user.clan_poa?
        scope.where(patient_id: user.patients.pluck(:id))
      elsif user.patient?
        scope.where(patient_id: user.id)
      else
        scope.none
      end
    end

    private

    attr_reader :user, :scope
  end

  private

  attr_reader :post
end
