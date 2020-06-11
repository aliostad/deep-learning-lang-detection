module Publinator
  class Manage::PublishableTypesController < ManageController
    def index
      @publishable_types = Publinator::PublishableType.all
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @manage_publishable_types }
      end
    end

    def show
      @manage_publishable_type = Manage::PublishableType.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @manage_publishable_type }
      end
    end

    def new
      @manage_publishable_type = Manage::PublishableType.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @manage_publishable_type }
      end
    end

    def edit
      @publishable_type = PublishableType.find(params[:id])
    end

    def create
      @manage_publishable_type = Manage::PublishableType.new(params[:manage_publishable_type])
      respond_to do |format|
        if @manage_publishable_type.save
          format.html { redirect_to manage_publishable_types_path, notice: 'Publishable type was successfully created.' }
          format.json { render json: @manage_publishable_type, status: :created, location: @manage_publishable_type }
        else
          format.html { render action: "new" }
          format.json { render json: @manage_publishable_type.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      @manage_publishable_type = Publinator::PublishableType.find(params[:id])
      respond_to do |format|
        if @manage_publishable_type.update_attributes(params[:manage_publishable_type])
          format.html { redirect_to manage_publishable_types_path, notice: 'Publishable type was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @manage_publishable_type.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @manage_publishable_type = Publinator::PublishableType.find(params[:id])
      @manage_publishable_type.destroy
      respond_to do |format|
        format.html { redirect_to manage_publishable_types_url }
        format.json { head :no_content }
      end
    end
  end
end
