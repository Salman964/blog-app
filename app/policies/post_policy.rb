class PostPolicy < ApplicationPolicy
  def users?
    user.users? || user.admin? || user.moderators?
  end

  def show?
    (@user.users? && @record.active?) || @user.admin? || @user.moderators?
  end

  def update?
    @user.id == @record.user_id
  end

  def destroy?
    @user.id == @record.user_id || @user.admin? || (@user.moderators? && Report.find_by(reportable_id: @record.id))
  end

  def check_moderator?
    @user.moderators?
  end

  alias_method "index?", :users?
  alias_method "new?", :users?
  alias_method "like_and_report?", :users?
  alias_method "approved?", :check_moderator?
  alias_method "rejected?", :check_moderator?
  alias_method "reported?", :check_moderator?
  alias_method "create?", :users?
  alias_method "like_destroy?", :users?
  alias_method "like?", :users?
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
