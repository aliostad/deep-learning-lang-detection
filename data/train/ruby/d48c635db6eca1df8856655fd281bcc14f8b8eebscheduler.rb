class Scheduler

  def self.schedule(repository, snapshot, metric)
    repository_id = repository.id
    snapshot_id = snapshot.date.to_s

    worker = MetricWorker.worker_class(metric)
    id = worker.send(:perform_async, repository_id, snapshot_id, metric)
    job = Job.where(repository: repository_id, 
                    snapshot: snapshot_id,
                    metric: metric)

    if job.exists?
      job.first.update_attributes!(sidekiq_id: id)
    else
      Job.create!(sidekiq_id: id,
                  repository: repository_id,
                  snapshot: snapshot_id, 
                  metric: metric)
    end
  end

end
