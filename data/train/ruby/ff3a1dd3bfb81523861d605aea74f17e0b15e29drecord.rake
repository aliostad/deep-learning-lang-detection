require 'api_helper'
include ApiHelper

namespace :record do
  desc 'record repository snapshot'

  task generate: :environment do
    url = URI.encode("https://api.github.com/search/repositories?q=stars:>50+pushed:>#{(Time.now - 1.day).strftime('%Y-%m-%d')}&type=Repositories&ref=searchresults")
    result =  get_json(url)
    objs = []
    result['items'].each do |repository|
      objs << RepositorySnapshot.new(
        name: repository['name'],
        html_url: repository['html_url'],
        stargazers_count: repository['stargazers_count'],
        language: repository['language'],
        create_date: Time.now.strftime('%Y-%m-%d')
      )
    end
    RepositorySnapshot.import(objs)
  end
end
