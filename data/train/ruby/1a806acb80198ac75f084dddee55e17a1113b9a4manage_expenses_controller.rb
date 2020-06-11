class ManageExpensesController < ApplicationController
  # GET /manage_expenses
  # GET /manage_expenses.json
  def index
    @manage_expenses = ManageExpense.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @manage_expenses }
    end
  end

  # GET /manage_expenses/1
  # GET /manage_expenses/1.json
  def show
    @manage_expense = ManageExpense.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @manage_expense }
    end
  end

  # GET /manage_expenses/new
  # GET /manage_expenses/new.json
  def new
    @manage_expense = ManageExpense.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @manage_expense }
    end
  end

  # GET /manage_expenses/1/edit
  def edit
    @manage_expense = ManageExpense.find(params[:id])
  end

  # POST /manage_expenses
  # POST /manage_expenses.json
  def create
    @manage_expense = ManageExpense.new(params[:manage_expense])

    respond_to do |format|
      if @manage_expense.save
        format.html { redirect_to @manage_expense, notice: 'Manage expense was successfully created.' }
        format.json { render json: @manage_expense, status: :created, location: @manage_expense }
      else
        format.html { render action: "new" }
        format.json { render json: @manage_expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /manage_expenses/1
  # PUT /manage_expenses/1.json
  def update
    @manage_expense = ManageExpense.find(params[:id])

    respond_to do |format|
      if @manage_expense.update_attributes(params[:manage_expense])
        format.html { redirect_to @manage_expense, notice: 'Manage expense was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @manage_expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage_expenses/1
  # DELETE /manage_expenses/1.json
  def destroy
    @manage_expense = ManageExpense.find(params[:id])
    @manage_expense.destroy

    respond_to do |format|
      format.html { redirect_to manage_expenses_url }
      format.json { head :no_content }
    end
  end
end
