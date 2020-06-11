require './boot'

use Rack::PostBodyContentTypeParser

run Rack::URLMap.new({
  "/api/v1/users"       => Backlogg::Api::V1::UsersController,
  "/api/v1/projects"    => Backlogg::Api::V1::ProjectsController,
  "/api/v1/sprints"     => Backlogg::Api::V1::SprintsController,
  "/api/v1/columns"     => Backlogg::Api::V1::ColumnsController,
  "/api/v1/tasks"       => Backlogg::Api::V1::TasksController,
  "/api/v1/comments"    => Backlogg::Api::V1::CommentsController,
  "/api/v1/templates"   => Backlogg::Api::V1::TemplatesController,
  "/api/v1"             => Backlogg::Api::V1::ApplicationController
})