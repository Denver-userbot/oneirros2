Apipie.configure do |config|
  config.app_name                = "Oneirros"
  config.api_base_url            = "/"
  config.doc_base_url            = "/apipie"
  config.default_version         = "2.0"
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.translate 		 = false
  config.default_locale          = nil
end
