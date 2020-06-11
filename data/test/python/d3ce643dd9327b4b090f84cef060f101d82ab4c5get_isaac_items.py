"""
Scrapes images and descriptions from BOI wiki

Usage: python get_isaac_items.py
 -- Assumes directory 'RESOURCE_PATH' exists.
 -- Saves the images from the 'Collection_Page' to disk.
 -- Saves the names/descriptions in a JSON file.

"""

from lib.get_trinkets import save_trinkets
from lib.get_items import save_items
from lib.get_rooms import tag_rooms
from lib.get_cards import save_cards


def main():
    save_items()
    save_cards()
    save_trinkets()
    tag_rooms()


if __name__ == "__main__":
    main()
