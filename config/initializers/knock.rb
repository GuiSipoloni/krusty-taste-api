Knock.setup do |config|

  config.token_signature_algorithm = 'HS256'
  config.token_secret_signature_key = -> { Rails.application.secrets.secret_key_base }
  config.not_found_exception_class_name = 'ActiveRecord::RecordNotFound'
  config.token_secret_signature_key = -> { Rails.application.credentials.read }
  
end