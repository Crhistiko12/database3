class SessionsController < ApplicationController
  allow_unauthenticated_access

  def new
  end

  def create
    @user = User.find_by(email_address: session_params[:email_address])

    if @user&.authenticate(session_params[:password])
      start_new_session_for @user
      redirect_to products_path, notice: "Sesión iniciada correctamente."
    else
      flash.now[:alert] = "Email o contraseña inválidos."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    end_session
    redirect_to root_path, notice: "Has cerrado sesión correctamente."
  end

  private

    def session_params
      params.require(:session).permit(:email_address, :password)
    end
end
