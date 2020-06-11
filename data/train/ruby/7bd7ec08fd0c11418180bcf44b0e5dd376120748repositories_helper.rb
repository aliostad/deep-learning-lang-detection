module AdminHelper::RepositoriesHelper

  def import_link(file)
    content_tag(:a, 'Import', class: 'import-link', data: { file: file }, href: '#' )
  end
  
  def import_metadata_link(repository, file)
    data = { file: file, repository: repository }
    content_tag(:a, 'Import', class: 'metadata-import-link', data: data , href: '#' )
  end

  def scheduler_anchor_tag(repository)
    href = "/admin/repositories/#{repository.id}/scheduler"
    content_tag(:a, repository.name, href: href)
  end

  def admin_repository_scheduler_snapshots_menu
    locals = { display: @repository.name,
               entities: @repositories,
               :parameter => :repository_id,
               :path => :admin_repository_scheduler_path }

    partial = render partial: 'shared/dropdown_menu', locals: locals
    content_tag(:li, partial, class: 'repository selector')
  end

end
