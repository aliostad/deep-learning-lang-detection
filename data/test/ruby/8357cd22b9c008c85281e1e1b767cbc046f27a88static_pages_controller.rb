class StaticPagesController < ApplicationController

  def home
    render layout: false
  end

  def snapshots
    repository = Repository.where(:snapshots.exists => true).first
    return render 'errors/no_snapshots' if repository.nil?

    snapshot = repository.snapshots.last
    parameter = { repository_id: repository.id, date: snapshot.date }
    redirect_to repository_snapshot_path(parameter)
  end

  def metrics
    Repository.all.each do |repository|
      repository.snapshots.each do |snapshot|
        Metrics::Metric.all.each do |metric|
          if not snapshot.send(metric.id).nil?
            path = repository_snapshot_metric_path(repository, snapshot, metric)
            return redirect_to path
          end
        end
      end
    end

    render 'errors/no_metrics'
  end

end
