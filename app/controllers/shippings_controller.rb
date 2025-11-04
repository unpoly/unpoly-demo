class ShippingsController < ApplicationController

  def new
    build_shipping
  end

  def create
    build_shipping
    @shipping.validate
    render 'new'
  end

  private

  def build_shipping
    @shipping = Shipping.new(shipping_params)
  end

  def shipping_params
    if (attrs = params[:shipping])
      attrs.permit(:continent, :country, :company, :weight, :gift)
    else
      {}
    end
  end

end