from mock import MagicMock

from stupid.chatbot import ChatBot, trigger
from stupid.slackbroker import SlackBroker


class Dummy(ChatBot):
    @trigger
    def on_hello(self):
        return 'hello'

    @trigger
    def on_bye(self):
        return self.say_bye()

    def say_bye(self):
        return 'bye'


def test_trigger_magic():
    broker = MagicMock(spec=SlackBroker)
    chatbot = Dummy(broker)
    assert chatbot.triggers == {
        'hello': chatbot.on_hello,
        'bye': chatbot.on_bye,
    }
    assert 'hello' == chatbot.on_message(1, {'text': 'hello'})
    broker.post.assert_called_once_with('hello')
