require 'spec_helper'

module Susply
  describe ChangePlansController, type: :controller do
    let(:time) { Time.zone.now }

    describe "#create" do
      before do
        @routes = Susply::Engine.routes
      end

      it "raises errors on not found plan" do
        expect{
          post :create, plan_id: 1
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "raises errors when there is not a current billable entity" do
        plan = create(:susply_plan)
        expect{
          post :create, plan_id: plan.id
        }.to raise_error(NoMethodError)
      end

      context "when billable entity cannot change plan" do
        before do
          @owner = Organization.create

          allow(@owner).to receive(:can_change_plan?).and_return(false)
          allow_any_instance_of(ApplicationController).
            to receive(:current_organization).and_return(@owner)

          @plan = create(:susply_plan, sku: 'new_plan')
        end

        it "redirects to owner path by default" do
          post :create, plan_id: @plan.id

          expect(response).to redirect_to owner_path(@owner)
        end

        it "redirects to provided path when set" do
          path = "/after_change_plan_fail"
          allow_any_instance_of(ApplicationController).
            to receive(:after_change_plan_fail_path).and_return(path)

          post :create, plan_id: @plan.id
          expect(response).to redirect_to path
        end

        it "sets the flash alert message" do
          post :create, plan_id: @plan.id

          expect(flash[:alert]).
            to eq I18n.t('susply.messages.failed_changed_plan')
        end
      end

      context "when billable entity change plan" do
        before do
          @owner = Organization.create
          create(:susply_subscription, :active, owner: @owner)

          allow(@owner).to receive(:can_change_plan?).and_return(true)
          allow_any_instance_of(ApplicationController).
            to receive(:current_organization).and_return(@owner)

          @plan = create(:susply_plan, sku: 'new_plan')
        end

        it "redirects to owner path by default" do
          post :create, plan_id: @plan.id

          expect(response).to redirect_to owner_path(@owner)
        end

        it "redirects to provided path when set" do
          path = "/after_change_plan_success"
          allow_any_instance_of(ApplicationController).
            to receive(:after_change_plan_success_path).and_return(path)

          post :create, plan_id: @plan.id
          expect(response).to redirect_to path
        end

        it "sets the flash notice message" do
          post :create, plan_id: @plan.id

          expect(flash[:notice]).
            to eq I18n.t('susply.messages.success_changed_plan')
        end
      end
    end
  end
end
