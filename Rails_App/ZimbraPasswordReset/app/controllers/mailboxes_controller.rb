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

end
