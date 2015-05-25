require_dependency "susply/application_controller"

module Susply
  class RenovationsController < ApplicationController
    before_filter :load_owner

    def create
      subscription = Susply::RenewsSubscription.call(@owner)
      if subscription
        redirect_to after_renovation_success_path,
          notice: t('susply.messages.success_renovation')
      else
        redirect_to after_renovation_fail_path,
          alert: t('susply.messages.failed_renovation')
      end
    end

    private
    def load_owner
      unless params[:owner_id].nil?
        searched_owner = Susply.subscription_owner_class.constantize.
          find(params[:owner_id])
        @owner = searched_owner
      end
    end

    def after_renovation_fail_path
      return super(@owner) if defined?(super)
      susply.owner_path(@owner)
    end

    def after_renovation_success_path
      return super(@owner) if defined?(super)
      susply.owner_path(@owner)
    end
  end
end
