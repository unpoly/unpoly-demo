ActionView::Helpers::FormBuilder.class_eval do

  def error_message(field, **options)
    errors = object.errors[field]

    options[:class] = "form-text form-error #{options[:class]}"

    if errors.present?
      @template.content_tag(:small, errors.first, **options)
    end
  end

end
