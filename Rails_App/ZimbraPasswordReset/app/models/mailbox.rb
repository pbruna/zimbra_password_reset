class Mailbox < ActiveRecord::Base
  attr_accessor :name, :lastname, :mail, :dn, :zimbra_id, :ldap_object

  # def initialize(ldap_object)
  #    @name = ldap_object[:givenname].try(:first)
  #    @lastname = ldap_object[:sn].try(:first)
  #    @mail = ldap_object[:zimbramaildeliveryaddress].try(:first)
  #    @dn = ldap_object[:dn]
  #    @zimbra_id = ldap_object[:zimbraid]
  #    super
  #  end
  
  def ldap_update_password(new_password)
    Devise::LdapAdapter.update_password(self.email,new_password)
  end
  
  def secondary_email
    UcscBackend::get_secondary_email(email)
  end
  
  def has_secondary_email?
    !secondary_email.nil?
  end
  
  def send_password_reset
    mailbox = Mailbox.find_by_email(self.email)
    mailbox.generate_token(:password_reset_token)
    mailbox.password_reset_sent_at = Time.zone.now
    mailbox.save!
    MailboxMailer.reset_password_instructions(mailbox).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while Mailbox.exists?(column => self[column])
  end

  def self.ldap_all
    mailboxes = Array.new
    params = {:ldap_auth_username_builder => Devise.ldap_auth_username_builder}
    ldap = Devise::LdapAdapter::LdapConnect.new(params).ldap
    ldap.auth ldap_config["admin_user"], ldap_config["admin_password"]
    ldap.bind
    ldap.search(
      :filter => Net::LDAP::Filter.eq("objectclass", "zimbraaccount"),
      :scope => Net::LDAP::SearchScope_WholeSubtree,
      :base => ""
    ).each do |ldap_object|
      mailboxes << Mailbox.new(ldap_object)
    end
    mailboxes.reject {|m| m.mail.nil?}
  end

  def self.ldap_find(email = "")
    raise "email blank" if email.blank?
    params = {:ldap_auth_username_builder => Devise.ldap_auth_username_builder}
    ldap = Devise::LdapAdapter::LdapConnect.new(params).ldap
    ldap.auth ldap_config["admin_user"], ldap_config["admin_password"]
    ldap.bind
    ldap_object = ldap.search(
      :base => dn(email), :scope => Net::LDAP::SearchScope_BaseObject
    )
    return false unless ldap_object
    Mailbox.find_or_create_by_email(ldap_object.first[:zimbramaildeliveryaddress].first)
  end
  
  private
  def self.dn(email)
    uid, domain = email.split("@")
    ldap_base = domain.split(/\./).map {|v| "dc=#{v}"}.join(",")
    "uid=#{uid},ou=people,#{ldap_base}"
  end
  
  def self.ldap_config
    APP_CONFIG
  end

end
