from datetime import date
from mock import patch, MagicMock
from stupid.holidaybot import HolidayBot
from stupid.slackbroker import SlackBroker


def test_holiday_title_for_new_year():
    bot = HolidayBot()
    assert "New Year's Day" == bot.holiday_title(date(2016, 1, 1))


def test_holiday_title_for_day_after_new_year():
    bot = HolidayBot()
    assert bot.holiday_title(date(2016, 1, 2)) is None


@patch("stupid.holidaybot.datetime.date")
def test_next_week_holiday_announcement(mock_date):
    mock_date.today.return_value = date(2016, 1, 11)
    broker = MagicMock(spec=SlackBroker)
    bot = HolidayBot(broker=broker)
    bot.post_next_week_holiday()
    broker.post.assert_called_once_with(
        "On the next week Monday, January 18 is day off - Birthday of Martin Luther King, Jr.",
        color='info'
    )


@patch("stupid.holidaybot.datetime.date")
def test_holiday_trigger(mock_date):
    mock_date.today.return_value = date(2016, 1, 11)
    broker = MagicMock(spec=SlackBroker)
    bot = HolidayBot(broker)
    bot.on_message(1, {"user": "x", "text": "@stupid: What are next holidays?"})
    broker.post.assert_called_once_with(
        "Monday, January 18 - Birthday of Martin Luther King, Jr.\n"
        "Monday, February 15 - Washington's Birthday\n"
        "Monday, May 30 - Memorial Day"
    )
