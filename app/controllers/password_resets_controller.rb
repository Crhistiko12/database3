class PasswordResetsController < ApplicationController
  allow_unauthenticated_access

  def new
  end

  def create
    @user = User.find_by(email_address: password_reset_params[:email_address])

    if @user
      @user.generate_password_reset_token!
      UserMailer.password_reset(@user).deliver_now
    end

    redirect_to new_session_path, notice: "Si el correo existe en la aplicación, recibirás un email con instrucciones para restablecer tu contraseña."
  end

  def edit
    @user = User.find_by(password_reset_token: params[:id])
    return redirect_to new_password_reset_path, alert: "El enlace ya no es válido." if @user.nil? || !@user.password_reset_token_valid?
  end

  def update
    @user = User.find_by(password_reset_token: params[:id])
    if @user.nil? || !@user.password_reset_token_valid?
      redirect_to new_password_reset_path, alert: "El enlace ya no es válido. Solicita uno nuevo." and return
    end

    if @user.update(password_reset_update_params)
      @user.clear_password_reset_token!
      redirect_to new_session_path, notice: "Tu contraseña se actualizó correctamente. Inicia sesión con tu nueva contraseña."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_reset_params
    params.require(:password_reset).permit(:email_address)
  end

  def password_reset_update_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
