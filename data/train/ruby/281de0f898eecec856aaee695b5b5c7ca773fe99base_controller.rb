class Api::BaseController < ApplicationController
  before_filter :authenticate_person!

  def authenticate_person!
    api_client = request.headers["X-Api-Client"]
    if api_client && api_client != ""
      authenticate_api!(api_client)
    else
      super
    end
  end

  def authenticate_api!(api_client)
    api_token = request.headers["X-Api-Token"]

    if !api_token || api_token == ""
      return unauthorized("X-Api-Token missing")
    end

    person = Person.find_by_api_token(api_token)
    if person
      @current_person = person
      # sign_in(person)
    else
      unauthorized("X-Api-Token invalid")
    end
  end

  def unauthorized(reason)
    render :status => 401, :json => {:error => reason}
  end
end
