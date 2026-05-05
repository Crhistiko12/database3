class HomeController < ApplicationController
  allow_unauthenticated_access only: :index

  def index
    redirect_to products_path if authenticated?
  end
end
