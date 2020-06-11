package redmine4s.api.model

import redmine4s.Redmine

case class Role(id: Long, name: String, inherited: Option[Boolean], permissions: Option[Iterable[Permission]], redmine: Redmine) {
  /** Returns the list of permissions for a given role. */
  def show(): Role = redmine.showRole(id)
}

object Permission {

  object AddDocuments extends Permission("add_documents")

  object AddIssueNotes extends Permission("add_issue_notes")

  object AddIssueWatchers extends Permission("add_issue_watchers")

  object AddIssues extends Permission("add_issues")

  object AddMessages extends Permission("add_messages")

  object AddProject extends Permission("add_project")

  object AddSubprojects extends Permission("add_subprojects")

  object BrowseRepository extends Permission("browse_repository")

  object CloseProject extends Permission("close_project")

  object CommentNews extends Permission("comment_news")

  object CommitAccess extends Permission("commit_access")

  object CopyIssues extends Permission("copy_issues")

  object DeleteDocuments extends Permission("delete_documents")

  object DeleteIssueWatchers extends Permission("delete_issue_watchers")

  object DeleteIssues extends Permission("delete_issues")

  object DeleteMessages extends Permission("delete_messages")

  object DeleteOwnMessages extends Permission("delete_own_messages")

  object DeleteWikiPages extends Permission("delete_wiki_pages")

  object DeleteWikiPagesAttachments extends Permission("delete_wiki_pages_attachments")

  object EditDocuments extends Permission("edit_documents")

  object EditIssueNotes extends Permission("edit_issue_notes")

  object EditIssues extends Permission("edit_issues")

  object EditMessages extends Permission("edit_messages")

  object EditOwnIssueNotes extends Permission("edit_own_issue_notes")

  object EditOwnMessages extends Permission("edit_own_messages")

  object EditOwnTimeEntries extends Permission("edit_own_time_entries")

  object EditProject extends Permission("edit_project")

  object EditTimeEntries extends Permission("edit_time_entries")

  object EditWikiPages extends Permission("edit_wiki_pages")

  object ExportWikiPages extends Permission("export_wiki_pages")

  object ImportIssues extends Permission("import_issues")

  object LogTime extends Permission("log_time")

  object ManageBoards extends Permission("manage_boards")

  object ManageCategories extends Permission("manage_categories")

  object ManageFiles extends Permission("manage_files")

  object ManageIssueRelations extends Permission("manage_issue_relations")

  object ManageMembers extends Permission("manage_members")

  object ManageNews extends Permission("manage_news")

  object ManageProjectActivities extends Permission("manage_project_activities")

  object ManagePublicQueries extends Permission("manage_public_queries")

  object ManageRelatedIssues extends Permission("manage_related_issues")

  object ManageRepository extends Permission("manage_repository")

  object ManageSubtasks extends Permission("manage_subtasks")

  object ManageVersions extends Permission("manage_versions")

  object ManageWiki extends Permission("manage_wiki")

  object ProtectWikiPages extends Permission("protect_wiki_pages")

  object RenameWikiPages extends Permission("rename_wiki_pages")

  object SaveQueries extends Permission("save_queries")

  object SelectProjectModules extends Permission("select_project_modules")

  object SetIssuesPrivate extends Permission("set_issues_private")

  object SetNotesPrivate extends Permission("set_notes_private")

  object SetOwnIssuesPrivate extends Permission("set_own_issues_private")

  object ViewCalendar extends Permission("view_calendar")

  object ViewChangesets extends Permission("view_changesets")

  object ViewDocuments extends Permission("view_documents")

  object ViewFiles extends Permission("view_files")

  object ViewGantt extends Permission("view_gantt")

  object ViewIssueWatchers extends Permission("view_issue_watchers")

  object ViewIssues extends Permission("view_issues")

  object ViewPrivateNotes extends Permission("view_private_notes")

  object ViewTimeEntries extends Permission("view_time_entries")

  object ViewWikiEdits extends Permission("view_wiki_edits")

  object ViewWikiPages extends Permission("view_wiki_pages")

  def fromString(expr: String): Permission = expr match {
    case "add_documents" => AddDocuments
    case "add_issue_notes" => AddIssueNotes
    case "add_issue_watchers" => AddIssueWatchers
    case "add_issues" => AddIssues
    case "add_messages" => AddMessages
    case "add_project" => AddProject
    case "add_subprojects" => AddSubprojects
    case "browse_repository" => BrowseRepository
    case "close_project" => CloseProject
    case "comment_news" => CommentNews
    case "commit_access" => CommitAccess
    case "copy_issues" => CopyIssues
    case "delete_documents" => DeleteDocuments
    case "delete_issue_watchers" => DeleteIssueWatchers
    case "delete_issues" => DeleteIssues
    case "delete_messages" => DeleteMessages
    case "delete_own_messages" => DeleteOwnMessages
    case "delete_wiki_pages" => DeleteWikiPages
    case "delete_wiki_pages_attachments" => DeleteWikiPagesAttachments
    case "edit_documents" => EditDocuments
    case "edit_issue_notes" => EditIssueNotes
    case "edit_issues" => EditIssues
    case "edit_messages" => EditMessages
    case "edit_own_issue_notes" => EditOwnIssueNotes
    case "edit_own_messages" => EditOwnMessages
    case "edit_own_time_entries" => EditOwnTimeEntries
    case "edit_project" => EditProject
    case "edit_time_entries" => EditTimeEntries
    case "edit_wiki_pages" => EditWikiPages
    case "export_wiki_pages" => ExportWikiPages
    case "import_issues" => ImportIssues
    case "log_time" => LogTime
    case "manage_boards" => ManageBoards
    case "manage_categories" => ManageCategories
    case "manage_files" => ManageFiles
    case "manage_issue_relations" => ManageIssueRelations
    case "manage_members" => ManageMembers
    case "manage_news" => ManageNews
    case "manage_project_activities" => ManageProjectActivities
    case "manage_public_queries" => ManagePublicQueries
    case "manage_related_issues" => ManageRelatedIssues
    case "manage_repository" => ManageRepository
    case "manage_subtasks" => ManageSubtasks
    case "manage_versions" => ManageVersions
    case "manage_wiki" => ManageWiki
    case "protect_wiki_pages" => ProtectWikiPages
    case "rename_wiki_pages" => RenameWikiPages
    case "save_queries" => SaveQueries
    case "select_project_modules" => SelectProjectModules
    case "set_issues_private" => SetIssuesPrivate
    case "set_notes_private" => SetNotesPrivate
    case "set_own_issues_private" => SetOwnIssuesPrivate
    case "view_calendar" => ViewCalendar
    case "view_changesets" => ViewChangesets
    case "view_documents" => ViewDocuments
    case "view_files" => ViewFiles
    case "view_gantt" => ViewGantt
    case "view_issue_watchers" => ViewIssueWatchers
    case "view_issues" => ViewIssues
    case "view_private_notes" => ViewPrivateNotes
    case "view_time_entries" => ViewTimeEntries
    case "view_wiki_edits" => ViewWikiEdits
    case "view_wiki_pages" => ViewWikiPages
  }
}

sealed abstract class Permission(val expr: String)
