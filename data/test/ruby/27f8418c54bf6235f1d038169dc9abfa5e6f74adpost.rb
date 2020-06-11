class Post < ActiveRecord::Base
  attr_accessor :delete, :bare
  attr_accessible :body, :title, :delete, :bare
  belongs_to :branch

  validates :title, presence: true, length: {maximum:30},
                    uniqueness: {scope: :branch_id}
  #validates :name, alpha_numeric: true

  def delete_file
    repository = self.branch.repository
    File.unlink("#{repository.working_dir}/#{self.title}")
  end

  def add_index
    repository = self.branch.repository
    new_file = open(self.path, "w"){|f| f.write(self.body)}
    new_blob = Grit::Blob.create(repository.repo, {name:self.title, data:new_file})
    Dir.chdir(repository.working_dir){repository.repo.add(new_blob.name)}
  end



  def remove_index
    repository = self.branch.repository
    repository.repo.remove("#{self.title}")
  end

  def rename
    repository = self.branch.repository
    Dir.chdir(repository.working_dir){File.rename(self.title_was, self.title)}
    repository.repo.remove(self.title_was)
  end

  def path
    repository = self.branch.repository
    "#{repository.working_dir}/#{self.title}"
  end

end
