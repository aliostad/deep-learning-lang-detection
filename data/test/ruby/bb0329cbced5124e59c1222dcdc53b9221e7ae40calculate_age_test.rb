require 'test_helper'

class AgeCalcTest < Test::Unit::TestCase
  def test_time_in_years
    pretend_now_is(2009,"sep",9) do    
      assert_equal "1 year", CalculateAge.of(425.days.ago)
      assert_equal "2 years", CalculateAge.of((2*380).days.ago)
      assert_equal "4 years", CalculateAge.of(4.years.ago, :in => "years")
      assert_equal "7 years", CalculateAge.of((8.years-1.day).ago)
    end
  end
    
  def test_time_in_months
    pretend_now_is(2009,"sep",9) do
      assert_equal "1 month", CalculateAge.of(45.days.ago,:in => "months")
      assert_equal "0 months", CalculateAge.of(4.days.ago,:in => "months")
      assert_equal "3 months", CalculateAge.of(3.months.ago,:in => "months")
      assert_equal "2 months", CalculateAge.of((3.months-1.day).ago,:in => "months")
      assert_equal "3 months", CalculateAge.of((3.months+1.day).ago,:in => "months")
      assert_equal "18 months", CalculateAge.of("3/8/2008",:in => "months")
      assert_equal "22 months", CalculateAge.of("11/08/2007", :in => "months")
      assert_equal "24 months", CalculateAge.of("9/09/2007", :in => "months")
    end
    
    pretend_now_is(2009,'sep',24) do
      assert_equal "10 months", CalculateAge.of(10.months.ago,:in => "months")
    end
  end
  
  def test_time_in_weeks
    pretend_now_is(2009,"sep",9) do
      assert_equal "1 week", CalculateAge.of(9.days.ago, :in => "weeks")
      assert_equal "7 weeks", CalculateAge.of(7.weeks.ago, :in => "weeks")
      assert_equal "3 weeks", CalculateAge.of(24.days.ago, :in => "weeks")
      assert_equal "1 week", CalculateAge.of(7.days.ago, :in => "weeks")
      assert_equal "4 weeks", CalculateAge.of(1.month.ago, :in => "weeks")
    end
  end
  
  def test_time_in_days
    pretend_now_is(2009,"sep",9,12) do
      assert_equal "9 days", CalculateAge.of(9.days.ago, :in => "days")
      assert_equal "49 days", CalculateAge.of(7.weeks.ago, :in => "days")
      assert_equal "24 days", CalculateAge.of(24.days.ago, :in => "days")
      assert_equal "7 days", CalculateAge.of(7.days.ago, :in => "days")
      assert_equal "31 days", CalculateAge.of(1.month.ago, :in => "days")
    end
  end
  
  def test_time_in_years_and_months
    pretend_now_is(2009,"sep",9) do
      assert_equal "1 month", CalculateAge.of(45.days.ago, :in => "years and months")
      assert_equal "4 years", CalculateAge.of(4.years.ago, :in => "years and months")
      assert_equal "2 years and 4 months", CalculateAge.of((2.years+130.days).ago, :in => "years and months")
      assert_equal "1 year and 5 months", CalculateAge.of(17.months.ago, :in => "years and months")
      assert_equal "1 year and 11 months", CalculateAge.of(23.months.ago, :in => "years and months")
    end
  end
  
  def test_february
    pretend_now_is(2009,"feb",28) do
      assert_equal "0 months", CalculateAge.of("2/1/2009", :in => "months")
      assert_equal "3 weeks", CalculateAge.of("2/1/2009", :in => "weeks")
    end
    
    pretend_now_is(2009,"mar",1) do
      assert_equal "1 month", CalculateAge.of("2/1/2009", :in => "months")
      assert_equal "4 weeks", CalculateAge.of("2/1/2009", :in => "weeks")
    end
  end
  
  def test_leap_year
    pretend_now_is(2009,"feb",1) do
      assert_equal "1 year", CalculateAge.of("1/31/2008")
      assert_equal "12 months", CalculateAge.of("1/31/2008", :in => "months")
    end
    
    pretend_now_is(2009,"feb",28) do
      assert_equal "0 years", CalculateAge.of("2/29/2008")
      assert_equal "11 months", CalculateAge.of("2/29/2008", :in => "months")
    end
    
    pretend_now_is(2008,"feb",29) do
      assert_equal "0 months", CalculateAge.of("1/31/2008", :in => "months")
      assert_equal "0 months", CalculateAge.of("2/1/2008", :in => "months")
      assert_equal "366 days", CalculateAge.of("2/28/2007", :in => "days")
      assert_equal "365 days", CalculateAge.of("3/1/2007", :in => "days")
    end
    
    pretend_now_is(2008,"mar",1) do
      assert_equal "1 month", CalculateAge.of("1/31/2008", :in => "months")
      assert_equal "1 month", CalculateAge.of("2/1/2008", :in => "months")
    end
    
    pretend_now_is(2008,"mar",31) do
      assert_equal "2 months", CalculateAge.of("1/31/2008", :in => "months")
      assert_equal "1 month", CalculateAge.of("2/1/2008", :in => "months")
    end
  end
  
  def test_for_dates_other_than_today
    assert_equal "2 months", CalculateAge.of("1/31/2008", :in => "months", :at => "3/31/2008")
    assert_equal "1 month", CalculateAge.of("2/1/2008", :in => "months", :at => "3/31/2008")
    assert_equal "0 months", CalculateAge.of("1/31/2008", :in => "months", :at => "2/29/2008")
    assert_equal "0 months", CalculateAge.of("2/1/2008", :in => "months", :at => "2/29/2008")
    assert_equal "366 days", CalculateAge.of("2/28/2007", :in => "days", :at => "2/29/2008")
    assert_equal "365 days", CalculateAge.of("3/1/2007", :in => "days", :at => "2/29/2008")
  end
  
  def test_for_future_dates
    assert_equal "2 months", CalculateAge.of(Date.today, :in => "months", :at => 2.months.from_now)
  end
end
