class UsersController < ApplicationController

  def index
    @users = User.all
  end
  
  def destroy
     @user = User.find(params[:id])
     respond_to do |format|
       if @user.destroy
         format.html {redirect_to users_path(), :notice => "Usuario eliminado correctamente"}
         format.json {head :no_content}
         format.js
       else
         flash[:error] = @user.errors[:base].first
         format.html {redirect_to users_path}
         format.json {render json: @user.errors, status: :unprocessable_entity}
         format.js
       end
     end
   end

  def new
    @user = User.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        format.html {redirect_to users_path, :notice => "Usuario creado correctamente."}
        format.js
      else
        logger.debug(@user.errors.messages)
        format.html {redirect_to users_path, :error => "No se pudo crear el usuario."}
        format.js
      end
    end
  end

  def edit
    @user = User.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html {redirect_to users_path, :notice => "Cambios guardados correctamente."}
        format.js
      else
        format.html {redirect_to users_path, :error => "No se pudo guardar."}
        format.js
      end
    end
  end

end
