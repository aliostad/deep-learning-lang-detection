import assassins.coerce_controller as coerce_controller
from ircbot import storage


def run():
    storage.initialize()

    coerce_controller.handle_join("#csb", "arctem")
    coerce_controller.handle_join("#csb", "barctem")
    coerce_controller.handle_join("#csb", "carctem")
    coerce_controller.handle_join("#csb", "darctem")
    coerce_controller.handle_join("#csb", "farctem")
    coerce_controller.handle_join("#csb", "garctem")
    coerce_controller.handle_quit("#csb", "garctem")
    coerce_controller.print_status("#csb")
    coerce_controller.start_game("#csb")
    coerce_controller.reset_game("#csb")
    coerce_controller.start_game("#csb")

    coerce_controller.handle_message("#csb", "arctem", "This is a test message. Isn't it cool?")
    with open('assassins/word_data/base.txt', 'r') as words:
        for word in words.read().strip().split('\n'):
            coerce_controller.handle_message("#csb", "arctem", word)
            print("GAME OVER: ", coerce_controller.check_game_over("#csb"))
            if coerce_controller.check_game_over("#csb"):
                coerce_controller.print_status("#csb")
                coerce_controller.finish_game("#csb")
                break
