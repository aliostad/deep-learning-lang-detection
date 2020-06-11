# encoding: utf-8
#--
#   Copyright (C) 2013-2014 Gitorious AS
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.
#
#   You should have received a copy of the GNU Affero General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++
require "commands/create_repository_command"

class CreateTrackingRepositoryCommand < CreateRepositoryCommand
  attr_reader :clone_in_foreground

  def initialize(app, repository, clone_in_foreground = false)
    super(app, repository.project, repository.user, {
        :owner => repository.owner,
        :kind => :tracking
      })
    @repository = repository
    @clone_in_foreground = clone_in_foreground
  end

  def build(params = nil)
    repository = super(NewRepositoryInput.new({
          :name => "tracking_repository_for_#{@repository.id}",
          :merge_requests_enabled => false
        }))
    repository.parent = @repository
    repository
  end

  def execute(repository)
    save(repository)
    initialize_committership(repository)
    initialize_membership(repository)
    create_git_repository(repository)
    repository
  end

  private

  def create_git_repository(repository)
    if async_creation?
      schedule_creation(repository, :queue => "GitoriousTrackingRepositoryCreation")
    else
      RepositoryCloner.clone(repository.parent.real_gitdir, repository.real_gitdir)
    end
  end

  def async_creation?
    !clone_in_foreground
  end
end
