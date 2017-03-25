class ProjectPresenter
  def initialize(project)
    @project = project
  end

  def created_at(view)
    view.content_tag(:created_at, project.created_at, "%B %e"))
  end

  def unique_work_types(project)
    works = project.works.group(["id", "source_from", "content_type"])
    works
  end

  private

  attr_reader :project
end
