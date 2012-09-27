# encoding: utf-8

class PasswordResetsController < ApplicationController
  skip_before_filter :authenticate_user!
  
  def edit
    begin
      @mailbox = Mailbox.find_by_password_reset_token!(params[:reset_password_token])
    rescue ActiveRecord::RecordNotFound => e
      flash[:alert] = "El código ingresado no es válido. Ingresa tu email para solicitar uno nuevo."
      redirect_to new_password_reset_path
    end
  end
  
  def update
    @mailbox = Mailbox.find_by_password_reset_token!(params[:mailbox][:reset_password_token])
    if params[:mailbox][:password] != params[:mailbox][:password_confirmation]
      flash[:error] = "Las contraseñas no coinciden."
      redirect_to edit_password_reset_path(@mailbox.id, :reset_password_token => @mailbox.password_reset_token)
    else
      @ldap_mailbox = Mailbox.ldap_find(@mailbox.email)
      if @ldap_mailbox.ldap_update_password(params[:mailbox][:password])
        @mailbox.password_reset_token = nil
        @mailbox.save
        @mailbox.send_password_change_notification
        flash[:notice] = "Contraseña actualizada correctamente"
      else
        flash[:error] = "No fue posible actualizar las contraseñas. Revise el log de error."
      end
      redirect_to new_password_reset_path
    end
  end
  
  def create
    @mailbox = Mailbox.ldap_find(params[:email])
    if @mailbox && @mailbox.has_secondary_email?
      @mailbox.send_password_reset
      flash[:notice] = "Se ha enviado un email a #{@mailbox.secondary_email} con las instrucciones."
      redirect_to new_password_reset_path
    elsif @mailbox && !@mailbox.has_secondary_email?
      flash[:alert] = "No tiene registrado una dirección de email de respaldo.".html_safe
      redirect_to new_password_reset_path
    else
      flash[:alert] = "No encontramos ningún usuario con el email ingresado".html_safe
      redirect_to new_password_reset_path
    end
    
  end
  
end
