class MailboxMailer < ActionMailer::Base
  default :from => "soporte@ucsc.cl"
  
  def reset_password_instructions(record)
    @mailbox = record
    mail(:to => @mailbox.secondary_email, :subject => "Password Reset")
  end
  
end