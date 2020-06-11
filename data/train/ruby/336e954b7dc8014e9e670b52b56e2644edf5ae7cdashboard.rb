class JijelWeb < Sinatra::Application

  get '/dashboard' do
    # TODO load sites
    # TODO load features
    # TODO calculate WIP percentage for each site
    # TODO calculate automated percentage for each site (# of automated cards / # of total cards in iteration (Mingle))
    # TODO get current iteration from Mingle
    # TODO calculate site passing percentage for this iteration (match current iteration in Mingle to the iteration tag)
    # TODO calculate site WIP percentage for this iteration (match current iteration in Mingle to the iteration tag with a wip tag as well)
    # TODO get number of regression scenarios for each site (regression tag)
    # TODO calculate site passing percentage for regression
    haml :dashboard
  end

end