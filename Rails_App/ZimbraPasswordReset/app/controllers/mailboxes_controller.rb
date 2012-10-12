# encoding: utf-8
class MailboxesController < ApplicationController

  def index

  end

  def show
    @mailbox = Mailbox.ldap_find(params[:id])
  end

  def edit
    @mailbox = Mailbox.ldap_find(params[:id])
  end

  def update
    @mailbox = Mailbox.ldap_find(params[:id])
    if params[:password] != params[:password_confirmation]
      flash[:error] = "Las contraseñas no coinciden."
      render :edit
    elsif invalid_password?(params[:password])
      flash[:error] = "La contraseña no cumple con la Política de Seguridad. Revise la Nota al final del cuadro."
      render :edit
    else
      if @mailbox.ldap_update_password(params[:password])
        flash[:notice] = "Contraseña actualizada correctamente"
      else
        flash[:error] = "No fue posible actualizar las contraseñas. Revise el log de error."
      end
      redirect_to mailboxes_path
    end
  end

  def search
    mailbox = Mailbox.ldap_find(params[:email])
    if mailbox
      redirect_to edit_mailbox_path(mailbox.email)
    else
      flash[:alert] = "No se encontraron resultados. Intente nuevamente."
      redirect_to mailboxes_path
    end
  end
  
  private
  def invalid_password?(password)
    min_size = APP_CONFIG["password_policy"]["min_size"]
    min_numbers = APP_CONFIG["password_policy"]["min_numbers"]
    min_lowercase = APP_CONFIG["password_policy"]["min_lowercase"]
    min_uppercase = APP_CONFIG["password_policy"]["min_uppercase"]
    password_pattern = /^((?=(.*[\d]){#{min_numbers},})(?=(.*[a-z]){#{min_lowercase},})(?=(.*[A-Z]){#{min_uppercase},})).{#{min_size},}$/
    return !password.match(password_pattern)
  end

end
