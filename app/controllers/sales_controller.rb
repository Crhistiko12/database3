class SalesController < ApplicationController
  def index
    @sales = Sale.includes(:product).where(product: current_user.products).order(created_at: :desc)
  end

  def show
    @sale = Sale.joins(:product).where(products: { user_id: current_user.id }).find(params[:id])
    product = @sale.product
    total = product.price * @sale.quantity

    pdf_data = generate_pdf(product, total)

    send_data pdf_data,
              filename: "venta_#{@sale.id}.pdf",
              type: "application/pdf",
              disposition: "attachment"
  end

  def create
    action_type = params[:action_type].presence || params.dig(:sale, :action_type).presence
    @sale = Sale.new(sale_params)
    product = current_user.products.find_by(id: @sale.product_id)

    if product.nil?
      respond_to do |format|
        format.js { render js: "alert('Producto inválido.')" }
        format.html { redirect_to products_path, alert: "Producto inválido." }
      end
      return
    end

    if action_type == "finalize"
      @sale.buyer_name = "Venta finalizada"
      @sale.buyer_email = "venta.finalizada@local"
    end

    if @sale.quantity.to_i > product.stock.to_i
      respond_to do |format|
        format.js { render js: "alert('No hay suficiente stock para completar la venta.')" }
        format.html { redirect_to products_path, alert: "No hay suficiente stock para completar la venta." }
      end
      return
    end

    ActiveRecord::Base.transaction do
      @sale.save!
      product.decrement!(:stock, @sale.quantity)
    end

    respond_to do |format|
      case action_type
      when "finalize"
        format.js { render js: "alert('Venta finalizada correctamente.'); window.location.reload();" }
        format.html { redirect_to products_path, notice: "Venta finalizada correctamente." }
      else
        total = product.price * @sale.quantity
        pdf_data = generate_pdf(product, total)

        format.js
        format.html do
          send_data pdf_data,
                    filename: "venta_#{@sale.id}.pdf",
                    type: "application/pdf",
                    disposition: action_type == "view" ? "inline" : "attachment"
        end
      end
    end
  rescue ActiveRecord::RecordInvalid
    respond_to do |format|
      format.js { render js: "alert('#{@sale.errors.full_messages.to_sentence}')" }
      format.html { redirect_to products_path, alert: @sale.errors.full_messages.to_sentence }
    end
  end

  private

  def generate_pdf(product, total)
    pdf = Prawn::Document.new(page_size: "A4", page_layout: :portrait, margin: 36)
    pdf.font_families.update("Inter" => {
      normal: Rails.root.join("app/assets/fonts/Inter-Regular.ttf"),
      bold: Rails.root.join("app/assets/fonts/Inter-Bold.ttf")
    }) if File.exist?(Rails.root.join("app/assets/fonts/Inter-Regular.ttf"))
    pdf.font("Inter") if pdf.font_families.key?("Inter")

    pdf.text "Recibo de venta", size: 28, style: :bold, align: :center
    pdf.move_down 18
    pdf.text "Producto: #{product.name}", size: 14
    pdf.text "Cantidad: #{@sale.quantity}", size: 14
    pdf.text "Precio unitario: $#{format('%.2f', product.price)}", size: 14
    pdf.text "Total: $#{format('%.2f', total)}", size: 14
    pdf.move_down 14
    pdf.text "Comprador:", style: :bold, size: 14
    pdf.text @sale.buyer_name, size: 14
    pdf.text @sale.buyer_email, size: 14
    pdf.move_down 14
    pdf.text "Fecha y hora: #{I18n.l(@sale.created_at, format: :long)}", size: 12
    pdf.move_down 18
    pdf.text "Gracias por su compra.", size: 12, align: :center

    pdf.render
  end

  def sale_params
    params.require(:sale).permit(:product_id, :buyer_name, :buyer_email, :quantity)
  end
end