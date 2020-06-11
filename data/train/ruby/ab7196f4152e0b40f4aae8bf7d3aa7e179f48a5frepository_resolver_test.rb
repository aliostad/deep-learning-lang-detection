# encoding: utf-8
#--
#   Copyright (C) 2012-2013 Gitorious AS
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
require "fast_test_helper"
require "gitorious/dolt/repository_resolver"

class StubRepository
  def self.full_repository_path=(path)
    @full_repository_path = path
  end

  def self.full_repository_path
    @full_repository_path
  end

  def self.find_by_path(name)
    repo = Repository.new
    repo.name = name
    repo.full_repository_path = full_repository_path
    repo
  end
end

class RepositoryResolverTest < MiniTest::Spec
  describe Gitorious::Dolt::RepositoryResolver do
    it "exposes repository presenter as meta" do
      StubRepository.full_repository_path = Rails.root.realpath.to_s
      resolver = Gitorious::Dolt::RepositoryResolver.new(StubRepository)
      repository = resolver.resolve("mainline")

      assert_equal "mainline", repository.meta.name
    end

    it "raises error if repository doesn't exist" do
      StubRepository.full_repository_path = "/tmp"
      resolver = Gitorious::Dolt::RepositoryResolver.new(StubRepository)

      assert_raises Rugged::RepositoryError do
        repository = resolver.resolve("mainline")
      end
    end
  end
end
