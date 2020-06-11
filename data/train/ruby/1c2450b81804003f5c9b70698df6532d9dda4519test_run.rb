def assert(condition)
  raise "Hell" unless condition
end

Repository.last.tasks.destroy_all

assert(Repository.last.tasks.count == 0)

RepositoryTaskExtractorWorker.perform(3)

assert(Repository.last.tasks.count == 7)

['bold', 'strong'].each do |task_name|
  task = Repository.last.tasks.where(name: task_name).first
  task.active = true
  task.save!
end

assert(Repository.last.tasks.where(active: true).count == 2)

assert(Repository.last.test_runs.count == 0)

RepositoryRunnerWorker.perform(3)

assert(Repository.last.test_runs.count == 1)
