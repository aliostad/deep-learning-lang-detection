# coding: utf-8

require "test/unit"
require_relative "../4_subtract_from_next_tuesday"

class TC_Foo < Test::Unit::TestCase
  def setup
    @dayofweek = {
      "Sun" => 0,
      "Mon" => 1,
      "Tue" => 2,
      "Wed" => 3,
      "Thu" => 4,
      "Fri" => 5,
      "Sut" => 6
    }
  end

  # -----------------------------------------------------------
  # next_week_dateで取得した日付が本当に一週間後の
  # その曜日の日付か確認するテスト
  # -----------------------------------------------------------
  def test_next_week_date
    assert_equal(CalculateTime.next_week_date(0).wday, @dayofweek["Sun"])
    assert_equal(CalculateTime.next_week_date(1).wday, @dayofweek["Mon"])
    assert_equal(CalculateTime.next_week_date(2).wday, @dayofweek["Tue"])
    assert_equal(CalculateTime.next_week_date(3).wday, @dayofweek["Wed"])
    assert_equal(CalculateTime.next_week_date(4).wday, @dayofweek["Thu"])
    assert_equal(CalculateTime.next_week_date(5).wday, @dayofweek["Fri"])
    assert_equal(CalculateTime.next_week_date(6).wday, @dayofweek["Sut"])
  end

  # -----------------------------------------------------------
  # 日付と曜日も表示
  # -----------------------------------------------------------
  def test_date_and_date_of_week
    puts "Check Date And Date Of Week"
    puts "#{CalculateTime.next_week_date(0)} | #{CalculateTime.next_week_date(0).wday}"
    puts "#{CalculateTime.next_week_date(1)} | #{CalculateTime.next_week_date(1).wday}"
    puts "#{CalculateTime.next_week_date(2)} | #{CalculateTime.next_week_date(2).wday}"
    puts "#{CalculateTime.next_week_date(3)} | #{CalculateTime.next_week_date(3).wday}"
    puts "#{CalculateTime.next_week_date(4)} | #{CalculateTime.next_week_date(4).wday}"
    puts "#{CalculateTime.next_week_date(5)} | #{CalculateTime.next_week_date(5).wday}"
    puts "#{CalculateTime.next_week_date(6)} | #{CalculateTime.next_week_date(6).wday}"
  end

end

