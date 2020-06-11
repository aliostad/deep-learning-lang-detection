require 'test_helper'

class BlobSubclass < Gitmain::Blob
end

class CommitSubclass < Gitmain::Commit
end

class TreeSubclass < Gitmain::Tree
end

class Gitmain::SubclassTest < Minitest::Test
  def test_repository_last_commit_returns_customizable_commit_instance
    setup_repository do |repository|
      rugged_repo = repository.instance_variable_get(:@_repo)
      assert repository.last_commit(klass: CommitSubclass).is_a?(CommitSubclass)
    end
  end

  def test_repository_tree_returns_customizable_tree_instance
    setup_repository do |repository|
      rugged_repo = repository.instance_variable_get(:@_repo)
      assert repository.tree(klass: TreeSubclass).is_a?(TreeSubclass)
    end
  end

  def test_tree_blobs_returns_customizable_blob_instances
    setup_repository do |repository|
      tree = Gitmain::Tree.new(repository, repository.tree_id)
      blob = tree.blobs(klass: BlobSubclass).first
      assert blob.is_a?(BlobSubclass)
    end
  end

  def test_trees
    setup_repository do |repository|
      tree = Gitmain::Tree.new(repository, repository.tree_id)
      tree = tree.trees(klass: TreeSubclass).first
      assert tree.is_a?(TreeSubclass)
    end
  end
end
