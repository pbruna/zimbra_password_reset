class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
         
  #before_save :get_ldap_email

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  
  def admin?
    begin
      Devise::LdapAdapter.get_ldap_param(email, "zimbraisadminaccount")
      result = true
    rescue
      result = false
    end
  end
  
  private
  def set_admin_role
    self.admin = Devise::LdapAdapter.get_ldap_param(self.email,"zimbraisadminaccount").first
  end
  
end
