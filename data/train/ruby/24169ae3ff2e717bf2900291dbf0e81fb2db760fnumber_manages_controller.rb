class NumberManagesController < ApplicationController
  # GET /number_manages
  # GET /number_manages.json
  def index
    @number_manages = NumberManage.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @number_manages }
    end
  end

  # GET /number_manages/1
  # GET /number_manages/1.json
  def show
    @number_manage = NumberManage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @number_manage }
    end
  end

  # GET /number_manages/new
  # GET /number_manages/new.json
  def new
    @number_manage = NumberManage.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @number_manage }
    end
  end

  # GET /number_manages/1/edit
  def edit
    @number_manage = NumberManage.find(params[:id])
  end

  # POST /number_manages
  # POST /number_manages.json
  def create
    @number_manage = NumberManage.new(params[:number_manage])

    respond_to do |format|
      if @number_manage.save
        format.html { redirect_to @number_manage, notice: 'Number manage was successfully created.' }
        format.json { render json: @number_manage, status: :created, location: @number_manage }
      else
        format.html { render action: "new" }
        format.json { render json: @number_manage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /number_manages/1
  # PUT /number_manages/1.json
  def update
    @number_manage = NumberManage.find(params[:id])

    respond_to do |format|
      if @number_manage.update_attributes(params[:number_manage])
        format.html { redirect_to @number_manage, notice: 'Number manage was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @number_manage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /number_manages/1
  # DELETE /number_manages/1.json
  def destroy
    @number_manage = NumberManage.find(params[:id])
    @number_manage.destroy

    respond_to do |format|
      format.html { redirect_to number_manages_url }
      format.json { head :no_content }
    end
  end
end
