module ApplicationHelper

  # def button_to(name = nil, options = nil, html_options = nil, &block)
  #   up_html_options, html_options = html_options.partition { |key, _value| key.to_s.start_with?('up-') }.map(&:to_h)
  #   html_options[:form] ||= {}
  #   html_options[:form].merge!(up_html_options)
  #   super(name, options, html_options, &block)
  # end

  def docs_link(label, path, **kwargs, &block)
    link_to(label, "https://unpoly.com" + path, target: '_blank', **kwargs, &block)
  end

  def page_head(title, &actions)
    title_div = content_tag(:div, content_tag(:h2, title), class: 'page-head--title')
    actions_div = content_tag(:div, class: 'page-head--actions', &(actions || proc {}))

    content_tag(:div, class: 'page-head') do
      title_div + actions_div
    end

  end

  def euros(amount)
    number_to_currency(amount, unit: '€', precision: 2)
  end

end
