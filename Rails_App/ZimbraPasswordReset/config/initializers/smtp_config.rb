ActionMailer::Base.default_url_options = { :host => 'localhost:3000' }
ActionMailer::Base.delivery_method = :letter_opener
#ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address        => "servidor.domain.com",
  :port           => 587,
  :domain         => "itlinux.cl",
  :user_name      => "soporte@itlinux.cl",
  :password       => "password",
  :enable_starttls_auto => false
}