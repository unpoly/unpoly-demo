module TourHelper

  def tour_dot(options = {}, &block)
    html = capture(&block).strip.html_safe

    # The margin looks nicer when the text is wrapped in <p> tags.
    # Wrap the given HTML in a <p> if the callerr hasn't already done so.
    unless html.starts_with?('<')
      html = content_tag(:p, html)
    end

    # # Add a button to close the hint popup.
    # html << <<~HTML.html_safe
    #   <p>
    #     <a href="#" up-dismiss class="btn btn-success btn-sm">OK</a>
    #   </p>
    # HTML

    # if strip_tags(html).size > 400
    #   size = 'large'
    # else
    #   size = 'medium'
    # end

    outline = options.fetch(:outline, {})

    html = content_tag(:div, html, class: 'tour-hint', 'up-data': { outline: outline }.to_json)

      # The hint is just an Unpoly popup.
    attrs = {
      class: 'tour-dot',
      href: '#',
      # 'up-layer': 'root',
      # 'up-peel': 'false',
      'up-layer': 'new drawer',
      'up-fragment': '' + html, # force-escape the HTML string by making it unsafe
      'up-position': options[:position],
      # 'up-align': options.fetch(:align, 'top'),
      'up-class': 'tour-hint-drawer',
      'up-size': options[:size],
    }.compact

    # This is a hint to hide this dot on the root layer (see application.sass).
    if options[:overlay_only]
      attrs['overlay-only'] = ''
    end

    # if (size = options[:size])
    #   attrs['up-size'] = size
    # end

    content_tag(:a, '', attrs)
  end

  def pre_code(**options, &block)
    html = capture(&block)
    html = html.strip_heredoc.strip
    html = CGI.escapeHTML(html)
    if (mark = options[:mark])
      mark = CGI.escapeHTML(mark)
      html = html.sub(mark) { |match| "<mark>#{match}</mark>" }
    end
    html = html.html_safe
    content_tag(:pre, content_tag(:code, html))
  end

end
