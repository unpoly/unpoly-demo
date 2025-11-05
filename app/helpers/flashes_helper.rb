module FlashesHelper

  def flashes
    html = ''.html_safe
    flash.map do |type, message|
      html << content_tag(:div, message, class: flash_classes(type), role: 'alert')
    end
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

  def flash_classes(type)
    "flash -#{flash_modifier_class(type)}"
  end

end
