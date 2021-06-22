class FragmentExplainer

  def initialize(controller)
    @controller = controller
  end

  def controller_short_path
    "#{controller_name}_controller.rb"
  end

  def controller_path
    "app/controllers/#{controller_short_path}"
  end

  def controller_github_url
    github_url(controller_path)
  end

  def view_short_path
    "#{controller_name}/#{view_name}.erb"
  end

  def view_path
    "app/views/#{view_short_path}"
  end

  def view_github_url
    github_url(view_path)
  end

  def layout_short_path
    "application.html.erb"
  end

  def layout_path
    "app/views/layouts/#{layout_short_path}"
  end

  def layout_github_url
    github_url(layout_path)
  end

  def up_target
    up.target
  end

  def title
    if up?
      "Updated fragment #{up_target}"
    else
      "Full page load"
    end
  end

  delegate :controller_name, :action_name, :up, :up?, to: :controller

  private

  def github_url(path)
    "https://github.com/unpoly/unpoly-demo/blob/master/#{path}"
  end

  def view_name
    name = action_name
    name = name.sub(/^create$/, 'new')
    name = name.sub(/^update$/, 'edit')
    name
  end

  attr_reader :controller

  # def relative_to_root(path)
  #   path.sub(Rails.root.to_s + '/', '')
  # end

end

# def track_view_path
#   subscriber = ActiveSupport::Notifications.subscribe "render_template.action_view" do |name, started, finished, unique_id, data|
#     @view_path = relative_to_root(data[:identifier])
#     @layout_path = relative_to_root(data[:layout])
#   end
#
#
#   @controller_path = "app/controllers/" + controller_name + "_controller.rb"
#   @view_path = "app/views/" + controller_name + "/" + action_name.sub('create', 'new').sub('update', 'edit') + ".html.erb"
#
#   yield
# ensure
#   ActiveSupport::Notifications.unsubscribe(subscriber)
# end
#
