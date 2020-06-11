"""Handle save prompt and character saving."""

from common import *
import pickle


def save(character):
    """Dump character data into external file."""
    save_file = open('save/arena.save', 'w')
    temp = character.next
    character.next = None
    pickle.dump(character, save_file)
    character.next = temp
    save_file.close()


def prompt(character):
    """Prompt for multiple save options."""
    clear()
    print color("""

  ____
 / ___|  __ ___   _____
 \___ \ / _` \ \ / / _ \\
  ___) | (_| |\ V /  __/
 |____/ \__,_| \_/ \___|
""", "pink")

    print_bar(0)
    print "Name:  %s" % character.name
    character.print_useful(True)
    save_options = [make_option('Save', 'S'),
                    make_option('Save and Exit', 'E'),
                    make_option('Quit', 'Q'),
                    make_option('Return', 'R')]

    print nav_menu(save_options, short=True)
    val = get_val("qsre")

    if "s" == val:
        save(character)
        character.move("town")

    elif "e" == val:
        save(character)
        exit()

    elif "q" == val:
        exit()

    elif "r" == val:
        character.move("town", printing=False)
