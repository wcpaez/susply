require 'spec_helper'

module Susply
  describe RenovationsController, type: :controller do
    let(:time) { Time.zone.now }

    describe "#create" do
      before do
        @routes = Susply::Engine.routes
      end

      it "raise an exception when no owner is finded" do
        expect{
          post :create, owner_id: 1
        }.to raise_error()
      end

      it "sets the owner variable to the searched one" do
        owner = Susply.subscription_owner_class.constantize.create
        post :create, owner_id: owner.id

        expect(assigns(:owner)).to eq owner
      end

      context "success response" do
        it "redirects to owner path by default" do
          owner = Susply.subscription_owner_class.constantize.create
          create(:susply_subscription, :active, owner: owner,
                 current_period_end: time - 1.day)
          post :create, owner_id: owner.id

          expect(response).to redirect_to owner_path(owner)
        end

        it "redirects to provided path when set" do
          path = "/new_after_success_path"
          allow_any_instance_of(ApplicationController).
            to receive(:after_renovation_success_path).and_return(path)
          owner = Susply.subscription_owner_class.constantize.create
          create(:susply_subscription, :active, owner: owner,
                 current_period_end: time - 1.day)
          post :create, owner_id: owner.id

          expect(response).to redirect_to path
        end

        it "sets the notice alert message" do
          owner = Susply.subscription_owner_class.constantize.create
          create(:susply_subscription, :active, owner: owner,
                 current_period_end: time - 1.day)
          post :create, owner_id: owner.id

          expect(flash[:notice]).
            to eq I18n.t('susply.messages.success_renovation')
        end
      end

      context "fail response" do
        it "redirects to owner path by default" do
          owner = Susply.subscription_owner_class.constantize.create
          post :create, owner_id: owner.id

          expect(response).to redirect_to owner_path(owner)
        end
        
        it "redirects to provided path when set" do
          path = "/new_after_fail_path"
          allow_any_instance_of(ApplicationController).
            to receive(:after_renovation_fail_path).and_return(path)

          owner = Susply.subscription_owner_class.constantize.create
          post :create, owner_id: owner.id

          expect(response).to redirect_to path
        end

        it "sets the alert flash message" do
          owner = Susply.subscription_owner_class.constantize.create
          post :create, owner_id: owner.id

          expect(flash[:alert]).
            to eq I18n.t('susply.messages.failed_renovation')
        end
      end
    end
  end
end
