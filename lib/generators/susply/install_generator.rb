module Susply
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../../templates", __FILE__)

    argument :subscription_owner_model, :type => :string, :required => true, 
      :desc => "Owner of the subscription"

    def subscription_owner_model
      @subscription_owner_model.capitalize
    end

    def billable_entity
      @subscription_owner_model.downcase
    end

    def install
      template "config/initializers/susply.rb"

      inject_into_class "app/models/#{subscription_owner_model.downcase}.rb", 
        subscription_owner_model.downcase.camelize.constantize,
        "# Added by Susply\n  include Susply::OwnerMethods  \n\n"

      copy_locales
    end

    def copy_locales
      copy_file "../../../config/locales/susply.en.yml",
        "config/locales/susply.en.yml"
    end
  end
end
