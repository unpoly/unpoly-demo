module PlaceholderHelper

  def placeholder(*content, &block)
    content_tag(:span, *content, class: 'placeholder', &block)
  end

end
