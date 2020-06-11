class Dip::InfaRepositoryController < ApplicationController
  layout "bootstrap_application_full"

  def index
    respond_to do |format|
      format.html
    end
  end

  def get_data
    repositories=Dip::InfaRepository.order("repository_domain_name,repository_alias")
    repositories=repositories.match_value("repository_alias", params[:repository_alias])
    repositories=repositories.match_value("repository_name", params[:repository_name])
    datas, count=paginate(repositories)
    respond_to do |format|
      format.html {
        @datas = datas
        @count = count
      }
    end
  end

  def create
    result={:success => true}
    repository=Dip::InfaRepository.new({:service_url => params[:service_url],
                                        :repository_domain_name => params[:repository_domain_name],
                                        :repository_name => params[:repository_name],
                                        :repository_alias => params[:repository_alias],
                                        :user_name => params[:user_name],
                                        :password => params[:password].to_s.size>0 ? Base64.strict_encode64(Dip::Des.encrypt(params[:password])) : nil,
                                        :user_namespace => params[:user_namespace]})
    unless (repository.save)
      result[:success]=false
    end
    result[:msg]=Dip::Utils.error_message_for(repository)
    respond_to do |format|
      format.json {
        render :json => result.to_json
      }
    end
  end

  def update
    result={:success => true}
    repository=Dip::InfaRepository.find(params[:id])
    unless repository.update_attributes({:service_url => params[:service_url],
                                         :repository_domain_name => params[:repository_domain_name],
                                         :repository_name => params[:repository_name],
                                         :repository_alias => params[:repository_alias],
                                         :user_name => params[:user_name],
                                         :password => Base64.strict_encode64(Dip::Des.encrypt(params[:password])),
                                         :user_namespace => params[:user_namespace]})
      result[:success]=false
    end
    result[:msg]=Dip::Utils.error_message_for(repository)
    respond_to do |format|
      format.json {
        render :json => result.to_json
      }
    end
  end

  def destroy
    Dip::InfaRepository.find(params[:id]).destroy
    respond_to do |format|
      format.json {
        render :json => {}.to_json
      }
    end
  end

  def get_repository_info
    respond_to do |format|
      format.json {
        repository=Dip::InfaRepository.find(params[:id])
        repository[:password]=Dip::Des.decrypt(Base64.strict_decode64(repository[:password]))
        render :json => repository.to_json
      }
    end
  end

  def synch
    result={:success => true}
    begin
      repository=Dip::InfaRepository.find(params[:id])
      sessionId=Dip::InfaRepository.login(repository)
      folders=Dip::InfaRepository.get_folder_list(repository, sessionId)
      #server=get_a_diServer(repository, sessionId)
      if folders && !folders.empty?
        folders.each do |f|
          workflows=Dip::InfaRepository.get_workflow_list(repository, sessionId, f[:name])
          if workflows
            workflows.each do |w|
              if Dip::InfaWorkflow.where({:repository_id => repository[:id], :name => w[:name], :folder_name => w[:folder_name]}).size<=0
                workflow=Dip::InfaWorkflow.new({:name => w[:name], :name_alias => w[:name], :folder_name => w[:folder_name], :repository_id => repository[:id]})
                workflow.save
              end
              #start_workflow(repository, sessionId, workflow, server)
            end
          end
        end
      end
      Dip::InfaRepository.logout(repository, sessionId)
      result[:msg]=[t(:label_operation_success)]
    rescue => ex
      result[:success]=false
      result[:msg]=[ex.to_s]
    end
    respond_to do |format|
      format.json {
        render :json => result.to_json
      }
    end
  end

end
