import President
import View 
import Controller
import Player
import Deck

if __name__ == "__main__":
	game = President.President()
	controller = Controller.Controller(game)
	view = View.View(game)
	done_adding = False
	while len(view.players) < 2 or not done_adding:
		view.before_start_show()
		done_adding = controller.register_player()
		view.update()
	controller.distribute_cards()
	view.update()
	view.show()

	while not view.game_over:
		view.show()
		move = controller.ask_move()
		if move == "pass":
			print "here"
			controller.make_move_pass()
		elif move == "":
			controller.make_move()

		view.update()
	view.show_winners()