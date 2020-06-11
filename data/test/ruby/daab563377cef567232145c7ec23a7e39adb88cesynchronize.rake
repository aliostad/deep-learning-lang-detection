require 'repository_puller'
namespace :synchronize do
  task latest_repository: :environment do
    RepositoryPuller.new('language:ruby stars:>25 created:>2015-01-01').perform!
    RepositoryPuller.new('react stars:>25 created:>2015-01-01').perform!
  end

  task repository_readme: :environment do
    Repository.find_each(&:synchronize_readme)
  end

  desc 'fetch the last week popular repository'
  task last_week_repository: :environment do
    created_at = 7.days.ago.to_date.to_s
    # RepositoryPuller.new("language:ruby stars:>25 created:>#{created_at}").perform!
    # RepositoryPuller.new("react stars:>25 created:>#{created_at}").perform!
    RepositoryPuller.new("stars:>25 created:>#{created_at}").perform!
  end
end
