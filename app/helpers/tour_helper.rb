module TourHelper

  def tour_dot(options = {}, &block)
    html = capture(&block).strip
    unless html.starts_with?('<')
      html = content_tag(:p, html)
    end
    html << <<~HTML.html_safe
      <p>
        <a href="#" up-dismiss class="btn btn-success btn-sm">OK</a>
      </p>
    HTML
    
    attrs = {
      class: 'tour-dot',
      href: '#',
      'up-layer': 'new popup',
      'up-content': '' + html, # force-escape the HTML string by making it unsafe
      'up-position': options.fetch(:position, 'right'),
      'up-align': options.fetch(:align, 'top'),
      'up-class': 'tour-hint'
    }

    if options[:overlay_only]
      attrs['overlay-only'] = ''
    end

    if (size = options[:size])
      attrs['up-size'] = size
    end

    content_tag(:a, '', attrs)
  end

end
