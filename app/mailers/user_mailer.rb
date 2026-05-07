class UserMailer < ApplicationMailer
  def password_reset(user)
    @user = user
    @reset_url = edit_password_reset_url(@user.password_reset_token)
    mail(to: @user.email_address, subject: "Restablece tu contraseña")
  end
end
