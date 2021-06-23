module TourHelper

  def tour_dot(options = {}, &block)
    html = capture(&block).strip.html_safe

    # The margin looks nicer when the text is wrapped in <p> tags.
    # Wrap the given HTML in a <p> if the callerr hasn't already done so.
    unless html.starts_with?('<')
      html = content_tag(:p, html)
    end

    # Add a button to close the hint popup.
    html << <<~HTML.html_safe
      <p>
        <a href="#" up-dismiss class="btn btn-success btn-sm">OK</a>
      </p>
    HTML

    if strip_tags(html).size > 400
      size = 'large'
    else
      size = 'medium'
    end

    # The hint is just an Unpoly popup.
    attrs = {
      class: 'tour-dot',
      href: '#',
      'up-layer': 'new popup',
      'up-content': '' + html, # force-escape the HTML string by making it unsafe
      'up-position': options.fetch(:position, 'right'),
      'up-align': options.fetch(:align, 'top'),
      'up-class': 'tour-hint',
      'up-size': size
    }

    # This is a hint to hide this dot on the root layer (see application.sass).
    if options[:overlay_only]
      attrs['overlay-only'] = ''
    end

    if (size = options[:size])
      attrs['up-size'] = size
    end

    content_tag(:a, '', attrs)
  end

end
