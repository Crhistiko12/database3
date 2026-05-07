class ProfilesController < ApplicationController
  def show
    @product_count = current_user.products.count
    @sales_count = Sale.joins(:product).where(products: { user_id: current_user.id }).count
    @revenue = Sale.joins(:product).where(products: { user_id: current_user.id }).sum("products.price * sales.quantity")
    @stock_total = current_user.products.sum(:stock)
  end
end
