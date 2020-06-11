#encoding: utf-8

class Manage::ItemsController < ApplicationController
  # GET /manage/items
  # GET /manage/items.json
  def index
    @items = Item.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
    end
  end

  # GET /manage/items/1
  # GET /manage/items/1.json
  def show
    @item = Item.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
    end
  end

  # GET /manage/items/new
  # GET /manage/items/new.json
  def new
    @item = Item.new
    @url = manage_items_path
    # @method = post

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item }
    end
  end

  # GET /manage/items/1/edit
  def edit
    @item = Item.find(params[:id])
    @url = manage_item_path(@item)
  end

  # POST /manage/items
  # POST /manage/items.json
  def create
    @item = Item.new(params[:item])
    @url = manage_items_path

    respond_to do |format|
      if @item.save
        format.html { redirect_to manage_items_path, notice: '商品が追加されました' }
        format.json { render json: @item, status: :created, location: @manage_item }
      else
        format.html { render action: "new" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /manage/items/1
  # PUT /manage/items/1.json
  def update
    @item = Item.find(params[:id])  
    @url = manage_item_path(@item)

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to manage_items_path, notice: '商品情報が更新されました' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage/items/1
  # DELETE /manage/items/1.json
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to manage_items_path }
      format.json { head :no_content }
    end
  end
end
