require 'test_helper'


class Gitmain::CommitTest < Minitest::Test
  def test_initialize_requires_repository
    assert_raises(ArgumentError) do
      Gitmain::Commit.new('', '')
    end
  end

  def test_initialize_requires_id
    assert_raises(ArgumentError) do
      empty_repository do |repository|
        Gitmain::Commit.new(repository, '')
      end
    end
  end

  def test_initialized_values_are_retrievable
    setup_repository do |repository|
      commit = Gitmain::Commit.new(repository, 'd3d5eb0dcc42e58901414e24eb8b02c8b699b2d9')
      assert_equal repository, commit.repository
      assert_equal 'd3d5eb0dcc42e58901414e24eb8b02c8b699b2d9', commit.id
    end
  end

  def test_author_email
    setup_repository do |repository|
      commit = Gitmain::Commit.new(repository, 'd3d5eb0dcc42e58901414e24eb8b02c8b699b2d9')
      assert_equal 'gitmain@local', commit.author_email
    end
  end

  def test_author_name
    setup_repository do |repository|
      commit = Gitmain::Commit.new(repository, 'd3d5eb0dcc42e58901414e24eb8b02c8b699b2d9')
      assert_equal 'Gitmain', commit.author_name
    end
  end

  def test_message
    setup_repository do |repository|
      commit = Gitmain::Commit.new(repository, 'd3d5eb0dcc42e58901414e24eb8b02c8b699b2d9')
      assert_equal 'Full Repository Commit', commit.message
    end
  end

  def test_parent_ids_with_root
    setup_repository do |repository|
      commit = Gitmain::Commit.new(repository, 'd3d5eb0dcc42e58901414e24eb8b02c8b699b2d9')
      assert_empty commit.parent_ids
    end
  end

  def test_parent_ids
    setup_repository do |repository|
      commit = Gitmain::Commit.new(repository, 'fb9d8f1ad958db545cc7b3374bed2b2c92db6545')
      assert_equal ['d3d5eb0dcc42e58901414e24eb8b02c8b699b2d9'], commit.parent_ids
    end
  end

  def test_time
    setup_repository do |repository|
      commit = Gitmain::Commit.new(repository, 'd3d5eb0dcc42e58901414e24eb8b02c8b699b2d9')
      assert commit.time == Time.new(2016, 2, 15, 1, 2, 3)
    end
  end
end
