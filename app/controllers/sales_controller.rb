class SalesController < ApplicationController
  def create
    action_type = params[:action_type].presence || params.dig(:sale, :action_type).presence
    @sale = Sale.new(sale_params)

    if action_type == "finalize"
      @sale.buyer_name = "Venta finalizada"
      @sale.buyer_email = "venta.finalizada@local"
    end

    if @sale.save
      case action_type
      when "finalize"
        redirect_to products_path, notice: "Venta finalizada correctamente."
      else
        product = @sale.product
        total = product.price * @sale.quantity

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
        pdf.move_down 18
        pdf.text "Gracias por su compra.", size: 12, align: :center

        disposition = action_type == "view" ? "inline" : "attachment"
        send_data pdf.render,
                  filename: "venta_#{@sale.id}.pdf",
                  type: "application/pdf",
                  disposition: disposition
      end
    else
      redirect_to products_path, alert: @sale.errors.full_messages.to_sentence
    end
  end

  private

  def sale_params
    params.require(:sale).permit(:product_id, :buyer_name, :buyer_email, :quantity)
  end
end
