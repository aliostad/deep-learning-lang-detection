json.user @user.name

json.boards @user.contrib_boards do |board|
  json.extract! board, :user_id, :id, :title, :repository_url, :repository_id, :pushed_at, :repository_name
end

json.repositories @user.repositories do |repository|
  json.id repository.github_id
  json.name repository.name
  json.url repository.url
  json.html_url repository.html_url
  json.pushed_at repository.pushed_at
  json.full_name repository.full_name
end

json.issues @user.issues do |issue|
  json.extract! issue, :id, :github_id, :number, :repository_name, :repository_id, :url, :html_url, :title, :body, :user_id, :username, :avatar_url
end
