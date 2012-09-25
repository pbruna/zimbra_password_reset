class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  protect_from_forgery
 
 
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end

  def after_sign_in_path_for(resource)
    mailboxes_path
  end

  private
    def block_normal_users!
      return if current_user.nil?
      sign_out(current_user) unless current_user.admin?
    end
    
    def ldap_config
      APP_CONFIG
    end

end
