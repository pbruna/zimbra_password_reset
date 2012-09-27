# encoding: utf-8

class MailboxMailer < ActionMailer::Base
  default :from => "soporte_correo@ucsc.cl"
  
  def reset_password_instructions(record)
    @mailbox = record
    mail(:to => @mailbox.secondary_email, :subject => "Instrucciones para cambiar contraseña")
  end
  
  def password_change_notification(record)
    @mailbox = record
    mail(:to => @mailbox.secondary_email, :subject => "Su contraseña fue cambiada correctamente")
  end
  
end