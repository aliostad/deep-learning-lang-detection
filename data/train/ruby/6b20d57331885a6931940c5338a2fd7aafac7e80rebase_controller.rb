# -*- encoding : utf-8 -*-
require 'sinatra/base'
require 'active_support/core_ext/object'

require_relative '../git'

module Agitable
  module Controllers
    class RebaseController < Sinatra::Base
      post '/rebase/:repository/from/:from_branch/to/:to_branch' do
        repository_name = params[:repository]
        repository = Agitable::Git::Repository.new("../#{repository_name}")

        content_type :json
        repository.rebase(params[:from_branch], params[:to_branch]).to_json
      end
    end
  end
end
