Redmine::Plugin.register :redmine_repository_tooltip do
  name 'Redmine Repository Tooltip plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/florentsolt/redmine_repository_tooltip'

  project_module :repository do
    permission :related_issues, {:repository_issues => [:issues]}, :read => true
  end
end

class RepositoryTooltipViewListener < ::Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context)
    stylesheet_link_tag("tooltipster.css", :plugin => "redmine_repository_tooltip", :media => "screen") +
    stylesheet_link_tag("tooltipster-shadow.css", :plugin => "redmine_repository_tooltip", :media => "screen") +
    javascript_include_tag("jquery.tooltipster.min.js", :plugin => "redmine_repository_tooltip") +
    javascript_include_tag("repository.js", :plugin => "redmine_repository_tooltip")
  end
end