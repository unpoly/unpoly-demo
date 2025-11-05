module FlashesHelper

  def flashes
    html = ''.html_safe
    flash.map do |type, message|
      html << content_tag(:div, message, class: flash_classes(type), role: 'alert', 'data-nonce': flash_nonce)
    end
    flash.clear
    html
  end

  def flash_modifier_class(type)
    case type.to_s
    when 'notice'
      'success'
    when 'error', 'alert'
      'danger'
    else
      'info'
    end
  end

  def flash_nonce
    # https://unpoly.com/flashes#caching
    SecureRandom.base64(32)
  end

  def flash_classes(type)
    "flash -#{flash_modifier_class(type)}"
  end

end
