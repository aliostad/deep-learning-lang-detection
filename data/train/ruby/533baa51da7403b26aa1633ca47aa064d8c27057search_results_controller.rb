class SearchResultsController < ApplicationController
  def show
    @member = Member.where('full_name LIKE ?', params[:query][:name]).first
    @average_bills_sponsored = average_bills_sponsored
    @average_bills_cosponsored = average_bills_cosponsored
    @average_amendments_sponsored = average_amendments_sponsored
    @average_amendments_cosponsored = average_amendments_cosponsored
  end

  private

  def average_bills_sponsored
    CalculateAverage.new(@member).calculate_average_number_of_bills
  end

  def average_bills_cosponsored
    CalculateAverage.new(@member).
      calculate_average_number_of_bills_cosponsored
  end

  def average_amendments_sponsored
    CalculateAverage.new(@member).
      calculate_average_number_of_amendments_sponsored
  end

  def average_amendments_cosponsored
    CalculateAverage.new(@member).
      calculate_average_number_of_amendments_cosponsored
  end
end
