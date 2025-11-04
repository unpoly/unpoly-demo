class Shipping
  class Estimate
    include Memoized

    delegate :helpers, to: ApplicationController

    Item = Struct.new(:label, :basis, :price, keyword_init: true)

    def initialize(shipping)
      @shipping = shipping
    end

    attr_reader :shipping

    memoize def base_fee
      if shipping.country == shipping.sender_country
        Item.new(label: 'Base fee', basis: 'National', price: 50)
      elsif shipping.continent == shipping.sender_continent
        Item.new(label: 'Base fee', basis: 'Europe', price: 140)
      else
        Item.new(label: 'Base fee', basis: 'World', price: 350)
      end
    end

    memoize def weight_surcharge
      unit_price = 2.5
      price = unit_price * shipping.weight
      Item.new(label: 'Weight surcharge', basis: "#{helpers.euros(unit_price)} / kg", price: price)
    end

    memoize def distance_surcharge
      unit_price = 0.02
      price = unit_price * shipping.distance
      Item.new(label: 'Distance surcharge', basis: "#{helpers.euros(unit_price)} / km", price: price)
    end

    memoize def subtotal
      subitems = [base_fee, weight_surcharge, distance_surcharge]
      Item.new(label: 'Subtotal', price: subitems.sum(&:price))
    end

    memoize def vat
      Item.new(label: 'VAT', basis: '19%', price: 0.19 * subtotal.price)
    end

    memoize def total
      Item.new(label: 'Total', price: subtotal.price + vat.price)
    end

  end
end