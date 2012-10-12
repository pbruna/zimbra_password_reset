class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable,
         :recoverable, :rememberable, :trackable
         
  before_destroy :ensure_there_is_one_user

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A[^@]+@[^@]+\z/
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
  
  def ensure_there_is_one_user
    return true if User.count > 1
    errors.add(:base, "Tiene que haber al menos un administrador")
    false
  end
  
end
