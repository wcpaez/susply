Susply.setup do |config|
  config.subscription_owner_class = "<%= subscription_owner_model %>"
  config.billable_entity = "current_<%= billable_entity %>"
end
