class RepositoriesController < ApplicationController
  def save
    params['repository']['scm_type'] = params['repository']['type']
    params['repository'].delete('type')
    params['repository']['period'] = params['repository']['process_period']
    params['repository'].delete('process_period')
    if !params['repository']['id'].nil? && params['repository']['id'].to_i != 0 && KalibroProcessor.request("repositories/#{params['repository']['id']}", {}, :get)["error"].nil?
      response = KalibroProcessor.request("repositories/#{params['repository']['id']}", {'repository' => params['repository']}, :put)
    else
      response = KalibroProcessor.request("repositories", {'repository' => params['repository']}) # Justs send projects instead of all the params
    end

    respond_to do |format|
      if response['repository']['errors'].nil?
        format.json { render json: response['repository'] }
      else
        format.json { render json: response['repository'], status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      format.json { render json: KalibroProcessor.request("repositories/#{params[:id]}", {}, :delete) }
    end
  end

  def of
    repositories = KalibroProcessor.request("projects/#{params[:project_id]}/repositories_of", {}, :get)

    respond_to do |format|
      repositories["repositories"].each do |repository|
        repository.delete("created_at")
        repository.delete("updated_at")
        repository["type"] = repository["scm_type"]
        repository.delete("scm_type")
        repository["process_period"] = repository["period"]
        repository.delete("period")
        repository.delete("code_directory")
      end
      format.json { render json: repositories }
    end
  end

  def process_repository
    respond_to do |format|
      format.json { render json: KalibroProcessor.request("repositories/#{params[:id]}/process", {}, :get) }
    end
  end

  def cancel_process
    respond_to do |format|
      format.json { render json: {}, status: :ok }
    end
  end

  def supported_types
    types = KalibroProcessor.request("repositories/types", {}, :get)

    types["supported_types"] = types["types"]
    types.delete("types")
    respond_to do |format|
      format.json { render json: types }
    end
  end
end
