require 'spec_helper'
require 'byebug'

module Susply
  describe RenovationsController, type: :controller do
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
    end
  end
end
