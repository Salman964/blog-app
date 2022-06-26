# frozen_string_literal: true

# app/policies/comment_policy.rb class
class CommentPolicy < ApplicationPolicy
  # class ProcedurePolicy
  def users?
    user.users? || user.admin? || user.moderators?
  end

  def destroy?
    @user.id == @record.user_id || @user.admin? || moderator_destroy_record
  end

  def moderator_destroy_record
    @user.moderators? && Report.find_by(reportable_id: @record.id)
  end

  alias_method "create?", :users?
  alias_method "like?", :users?
  alias_method "like_destroy?", :users?
  alias_method "like_destroy?", :users?
  alias_method "report?", :users?
  alias_method "report_destroy?", :users?
  alias_method "new?", :users?
  # end

  # app/policy/comment_policy/scope.rb class
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end
end
