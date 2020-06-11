class Manage::BuildController < ApplicationController
  before_filter :check_installation

  def building
    redirect_to manage_install_index_path unless Dropboxr::Connector.connection.authorized?

    Dropboxr::Connector.connection.build_galleries

    redirect_to done_manage_build_index_path
  end

  def collecting
    redirect_to manage_install_index_path unless Dropboxr::Connector.connection.authorized?

    Dropboxr::Connector.connection.collect_galleries

    redirect_to done_manage_build_index_path
  end

  def done
  end

  def error
  end

  private

    def check_installation
      redirect_to root_path if Installation.installed.empty?
    end

end
