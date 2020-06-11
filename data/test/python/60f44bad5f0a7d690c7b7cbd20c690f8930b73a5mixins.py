from controllers.event_controller import EventController
from controllers.game_controller import GameController
from events import Event


class CardTypeMixin(object):
    type_name = ''

    def card_type_init(self):
        EventController.register(self, Event.PLAY, self.play_card_event)

    def play_card_event(self, player, **kwargs):
        if self.mana_cost:
            if not GameController.can_spend_mana(player, self.mana_cost):
                GameController.print_message('ERROR cannot play card, not enough mana: %s\n' % self)
                return

        player.hand.remove(self)
        player.battlefield.append(self)
        player.spend_mana(self.mana_cost)
        GameController.print_message(GameController.get_mana_string(player))
        GameController.print_message('player played a card: %s\n' % self)

