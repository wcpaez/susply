require_dependency "susply/application_controller"

module Susply
  class RenovationsController < ApplicationController
    before_filter :load_owner

    def create
      subscription = Susply::RenewsSubscription.call(@owner)

      render json: {}

    end

    private
    def load_owner
      unless params[:owner_id].nil?
        searched_owner = Susply.subscription_owner_class.constantize.
          find(params[:owner_id])
        @owner = searched_owner
      end
    end
  end
end
