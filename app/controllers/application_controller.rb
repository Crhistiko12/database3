class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :load_current_user
  before_action :authenticate_user!

  helper_method :authenticated?, :current_user

  class << self
    def allow_unauthenticated_access(*actions, **options)
      skip_before_action :authenticate_user!, *actions, **options
    end
  end

  def start_new_session_for(user)
    session[:user_id] = user.id
    Current.user = user
  end

  def end_session
    session.delete(:user_id)
    Current.user = nil
  end

  def authenticated?
    current_user.present?
  end

  def current_user
    Current.user
  end

  private

  def authenticate_user!
    return if authenticated?

    redirect_to new_session_path, alert: "Debes iniciar sesión para continuar."
  end

  def load_current_user
    Current.user = User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
