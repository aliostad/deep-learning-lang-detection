class ApiTestsController < ApplicationController
  # GET /api_tests
  # GET /api_tests.json
  def index
    @api_tests = ApiTest.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @api_tests }
    end
  end

  # GET /api_tests/1
  # GET /api_tests/1.json
  def show
    @api_test = ApiTest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @api_test }
    end
  end
  
  def run_test
    @api_test = ApiTest.find(params[:id])
    @test_result = @api_test.test_results.create
    debugger
    HardWorker.perform_async(@api_test.id, @test_result.id)
  end
  
  # GET /api_tests/new
  # GET /api_tests/new.json
  def new
    @api_test = ApiTest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @api_test }
    end
  end

  # GET /api_tests/1/edit
  def edit
    @api_test = ApiTest.find(params[:id])
  end

  # POST /api_tests
  # POST /api_tests.json
  def create
    @api_test = ApiTest.new(params[:api_test])

    respond_to do |format|
      if @api_test.save
        format.html { redirect_to @api_test, notice: 'Api test was successfully created.' }
        format.json { render json: @api_test, status: :created, location: @api_test }
      else
        format.html { render action: "new" }
        format.json { render json: @api_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /api_tests/1
  # PUT /api_tests/1.json
  def update
    @api_test = ApiTest.find(params[:id])

    respond_to do |format|
      if @api_test.update_attributes(params[:api_test])
        format.html { redirect_to @api_test, notice: 'Api test was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @api_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api_tests/1
  # DELETE /api_tests/1.json
  def destroy
    @api_test = ApiTest.find(params[:id])
    @api_test.destroy

    respond_to do |format|
      format.html { redirect_to api_tests_url }
      format.json { head :no_content }
    end
  end
end
