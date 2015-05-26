require_dependency "susply/application_controller"

module Susply
  class ChangePlansController < ApplicationController
    def create
      plan = Susply::Plan.find(params[:plan_id])
      if current_owner.can_change_plan?(plan)
        Susply::ChangeSubscription.call(current_owner, plan)
        redirect_to after_change_plan_success_path,
          notice: t('susply.messages.success_changed_plan')
      else
        redirect_to after_change_plan_fail_path,
          alert: t('susply.messages.failed_changed_plan')
      end
    end

    private
    def current_owner
      @current_owner ||= send(Susply.billable_entity)
    end

    def after_change_plan_fail_path
      return super(@current_owner) if defined?(super)
      susply.owner_path(@current_owner)
    end

    def after_change_plan_success_path
      return super(@current_owner) if defined?(super)
      susply.owner_path(@current_owner)
    end
  end
end
