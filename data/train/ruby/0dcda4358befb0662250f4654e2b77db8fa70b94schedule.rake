task :schedule, [:repository, :snapshot_date, :metric_id] => :environment do |t, args|

  repository_id = args[:repository]
  snapshot_date = args[:snapshot_date]
  metric_id = args[:metric_id]

  if repository_id.nil?
    Repository.all.each do |repository|
      repository.snapshots.each do |snapshot|
        Metrics::Metric.all.each do |metric|
          Scheduler.schedule(repository, snapshot, metric.id)
        end
      end
    end
  elsif snapshot_date.nil?
    repository = Repository.where(id: repository_id).first
    repository.snapshots.each do |snapshot|
      Metrics::Metric.all.each do |metric|
        Scheduler.schedule(repository, snapshot, metric.id)
      end
    end
  elsif metric_id.nil?
    repository = Repository.where(id: repository_id).first
    snapshot = repository.snapshots.where(date: snapshot_date).first
    Metrics::Metric.all.each do |metric|
      Scheduler.schedule(repository, snapshot, metric.id)
    end
  else
    repository = Repository.where(id: repository_id).first
    snapshot = repository.snapshots.where(date: snapshot_date).first
    Scheduler.schedule(repository, snapshot, metric_id)
  end
end

