class AdministrationController < ApplicationController
  authorize_resource :class => false
  before_filter :authenticate_user!

  def index

  end

  def manage_categories
    @categories = Category.all
    render "categories/index"
  end

  def manage_collections
    @collections = Collection.all
  end

  def manage_images
    @images = Image.all
  end

  def manage_tags
    @tags = Tag.all
    render "tags/index"
  end

  def manage_users
    @users = User.all
  end

  def manage_user
    @user = User.find(params[:id])
  end

  def manage_user_update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to manage_user_administration_path(@user), notice: @user.email + ' was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "manage_user"}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
end
