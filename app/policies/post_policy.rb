class PostPolicy < ApplicationPolicy
  def users?
    user.user? || user.admin? || user.moderator?
  end

  def show?
    record.approved?
  end

  def update?
    @user.id == @record.user_id
  end

  def destroy?
    @user.id == @record.user_id || @user.admin? || moderator_destroy_record
  end

  def moderator_destroy_record
    @user.moderator? && Report.find_by(reportable_id: @record.id)
  end

  def check_moderator?
    @user.moderator?
  end

  def approved?
    current_user.moderator?
  end

  alias_method "index?", :users?
  alias_method "new?", :users?
  alias_method "approved?", :check_moderator?
  alias_method "rejected?", :check_moderator?
  alias_method "reported?", :check_moderator?
  alias_method "create?", :users?
  alias_method "pending?", :users?
  alias_method "myrejected?", :users?
  alias_method "report?", :users?
  alias_method "report_destroy?", :users?
  # end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end
end
