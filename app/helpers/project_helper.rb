module ProjectHelper

  def star_project(project)
    label = project.star? ? '★' : '☆'
    link_to label, project, method: :patch, 'up-target': '.project:closest .star'
  end

end
