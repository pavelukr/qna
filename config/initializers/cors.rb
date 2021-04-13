Rails.application.config.middleware.insert_before 0, Rack::Cors do
  # skip_client_authentication_for_password_grant true
  # Rails.application.config.hosts << 'extendsclass.com'
  allow do
    origins '*'
    resource '*', headers: :any, methods: %i[get post patch put]
  end
end
