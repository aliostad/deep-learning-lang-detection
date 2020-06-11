class ChunksController < ApplicationController
  load_and_authorize_resource
  respond_to :json
  before_filter :get_asset_and_package

  def get_asset_and_package
    @asset = Asset.find(params[:asset_id])
    @package = Package.find(@asset.package_id)
  end
  
  def index
    @chunks = Chunks.where(user_id => current_user.id)
    respond_with(@chunks)
  end

  def show
    respond_with(@package, @asset, @chunk)
  end

  def new
    @chunk = @asset.chunks.build
    respond_with(@chunk)
  end

  def edit
    respond_with(@chunk)
  end

  def create
    @chunk = @asset.chunks.build(:chunk => params[:asset]["file"])
    @chunk.user_id = current_user.id
    if @chunk.save
      flash[:notice] = 'Chunk was successfully created.'
    end
    render json: @chunk
  end

  def update
    if @chunk.update_attributes(params[:chunk])
      flash[:notice] = 'Chunk was successfully updated.'
    end
    respond_with(@chunk)
  end

  def destroy
    @chunk.destroy
    respond_with(@chunk)
  end
end
