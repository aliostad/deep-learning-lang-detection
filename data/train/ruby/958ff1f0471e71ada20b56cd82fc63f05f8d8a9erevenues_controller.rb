class RevenuesController < ApplicationController
  def index
    @revenue = Revenue.calculate_all
    @sold = Purchase.calculate_sold
    @bought = Purchase.calculate_bought
    @expense = Expense.calculate_all

    @total = (@revenue + @sold)
    @total -= @bought
    @total -= @expense
  end

  def list
    @revenues = Revenue.all
  end

  def new
    @revenue = Revenue.new
  end

  def create
    @revenue = Revenue.new(params[:revenue])
    if @revenue.save
      redirect_to list_revenues_path
    end
  end

  def destroy
    revenue = Revenue.find(params[:id])
    revenue.destroy
    redirect_to list_revenues_path
  end
end
