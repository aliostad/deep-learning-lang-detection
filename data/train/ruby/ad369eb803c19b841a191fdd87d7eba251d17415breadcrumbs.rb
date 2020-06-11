# coding: utf-8
crumb :student_root do
  link "学生ホーム", root_path
end

crumb :student_tasks do
  link "課題一覧", tasks_path
  parent :student_root
end

crumb :show_student_task do
  link "課題詳細", task_path
  parent :student_root
end

crumb :student_task_submissions do
  link "提出履歴", task_submissions_path
  parent :student_root
end

crumb :show_student_task_submission do
  link "提出履歴詳細", task_submission_path
  parent :student_task_submissions
end

crumb :edit_student_report do
  link "レポートコメント", edit_report_path
  parent :student_root
end
crumb :manage_root do
  link "管理者ホーム", manage_root_path
end

crumb :manage_students do
  link "学生一覧", manage_students_path
  parent :manage_root
end

crumb :show_manage_student do |student|
  link "学生詳細", student
  parent :manage_students
end

crumb :edit_manage_student do
  link "学生情報編集", edit_manage_student_path
  parent :manage_students
end

crumb :manage_student_submissions do
  link "学生提出状況一覧", manage_student_submissions_path
  parent :show_manage_student
end

crumb :show_manage_student_submission do
  link "学生提出詳細", manage_student_submission_path
  parent :manage_student_submissions
end

crumb :edit_manage_student_submission do
  link "採点", edit_manage_student_submission_path
  parent :show_manage_student_submission
end

crumb :edit_manage_student_report do
  link "レポート採点", edit_manage_student_report_path
  parent :show_manage_student
end

crumb :manage_tasks do
  link "課題一覧", manage_tasks_path
  parent :manage_root
end

crumb :show_manage_task do |task|
  link "課題詳細", task
  parent :manage_tasks, task
end

crumb :edit_manage_task do
  link "課題編集", edit_manage_task_path
  parent :manage_tasks
end

crumb :new_manage_task do
  link "課題新規作成", new_manage_task_path
  parent :manage_root
end

crumb :manage_task_test_cases do
  link "テストケース一覧", manage_task_test_cases_path
  parent :show_manage_task
end

crumb :new_manage_task_test_case do
  link "テストケース追加", new_manage_task_test_case_path
  parent :show_manage_task
end

crumb :edit_manage_task_test_case do
  link "テストケース編集", edit_manage_task_test_case_path
  parent :manage_task_test_cases
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
