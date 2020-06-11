# encoding: utf-8
class AdController < ApplicationController

  before_filter :log_ad_changes, only: [:update_ad, :pause_ad]

  def new
    @ad = Ad.new
  end

  def post_ad

    # create owner # TODO check for possible owners without ads or make it as a transaction
    owner = Owner.new({password: generate_password()})
    owner.save

    @ad = Ad.new(params[:ad])
    @ad.status = 'submitted'
    @ad.general_ad_id = owner.id
    @ad.general_ad_type = 'Owner'
    @ad.end_date = DateTime.current + 7.days

    # TODO check for duplicates

    if @ad.save
      redirect_to :successful_submit, flash: { id: @ad.id, password: @ad.general_ad.password }
    else
      render 'new'
    end
  end

  def successful_submit
    render nothing: true if flash[:id].nil? || flash[:password].nil?
  end

  # manage ad
  def manage
    if session[:manage_ad].nil?
      render 'manage_ad_login_form'
    else
      @ad = Ad.find(session[:manage_ad])
      if @ad
        render 'manage_ad'
      else
        manage_logout
      end

    end
  end
  
  def manage_login

    if params[:ad_id].to_i == 0
      flash[:error] = 'Укажите номер объявления'
      redirect_to controller: :ad, action: :manage and return
    end

    @ad = Ad.find(params[:ad_id])

    if @ad && @ad.general_ad_type.eql?('Owner') && @ad.general_ad.password.eql?(params[:password])
      session[:manage_ad] = @ad.id
      @ad.general_ad.update_column('last_login', DateTime.current)
      redirect_to controller: :ad, action: :manage
    else
      flash[:error] = 'Неверный номер объявления или пароль'
      redirect_to controller: :ad, action: :manage
    end
  end

  def manage_logout
    session[:manage_ad] = nil
    redirect_to controller: :ad, action: :manage
  end

  def update_ad
    data = params[:ad]
    data[:status] = 'changed'

    Ad.find(session[:manage_ad]).update_attributes(data)

    flash[:notice] = "Объявление успешно изменено"
    redirect_to controller: :ad, action: :manage
  end

  def pause_ad
    ad = Ad.find(session[:manage_ad])

    if ad.status == 'published'
      ad.update_column('status', 'paused')
      flash[:notice] = "Публикация объявления приостановлена"
    end

    redirect_to controller: :ad, action: :manage
  end

  # extend publishing for another week
  def republish_ad
    ChangeLogger.log(session[:manage_ad]) # TODO log end_date changes

    ad = Ad.find(session[:manage_ad])

    if ad.status == 'published'
      ad.end_date += 7.days
      ad.save

      flash[:notice] = "Публикация объявления продлена на неделю"
      redirect_to controller: :ad, action: :manage
    end
  end

  # continue publication after it's being paused
  def continue_ad
    ad = Ad.find(session[:manage_ad])

    if ad.status == 'paused'
      ChangeLogger.log(session[:manage_ad])

      ad.update_column('status', 'published')

      unless ad.end_date.future?
        ad.update_column('end_date', ad.end_date += 7.days)
      end

      flash[:notice] = "Публикация объявления возобновлена"
      redirect_to controller: :ad, action: :manage

    end
  end

  private
    def log_ad_changes
      ChangeLogger.log(session[:manage_ad])
    end

    # generate random string, unique for Owner
    def generate_password
      password = SecureRandom.hex[0, 8]

      if Owner.find_by_password(password).nil?
        password.to_s
      else
        generate_password
      end
    end
end
