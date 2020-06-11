# -*- encoding : utf-8 -*-
class ManageRelationshipsController < ApplicationController
  authorize_resource
  
  def create
    @manage_relationship = ManageRelationship.new
    @enterprise = Enterprise.find_by_code(params[:enterprise_code])
    @user = User.find(params[:user_id])
    if @user && @enterprise
      @manage_relationship.user_id = @user.id
      @manage_relationship.enterprise_id = @enterprise.id
    end
    if @manage_relationship.save
      flash[:success] = "新增授权企业成功"
    else
      flash[:error] = "新增授权企业失败,输入空值或可能该企业已经授权"
    end  
    redirect_to enterprises_user_path(@user)
  end

  def destroy
    @manage_relationship = ManageRelationship.find(params[:id])
    @user = User.find(@manage_relationship.user_id)
    @manage_relationship.destroy
    flash[:success] = "成功取消企业授权"
    redirect_to enterprises_user_path(@user)
  end
end
