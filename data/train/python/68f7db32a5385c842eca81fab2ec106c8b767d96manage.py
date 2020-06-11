#!/usr/bin/env python
from sys import argv

manage_methods = {}


def manage(method):
    def wrap(*args, **kwargs):
        print("Calling management task {}".format(method.__name__))
        method(*args, **kwargs)
        print("Done with {}".format(method.__name__))

    manage_methods[method.__name__] = wrap

    return wrap


def main():
    manage_methods[argv[1]]()


@manage
def retrieve_images():
    from twogifs.images import ImageRetriever
    ImageRetriever().retrieve_images()


@manage
def remove_invalid_scores():
    from twogifs.data import ImageRanking
    ImageRanking().remove_invalid_scores()


@manage
def runserver():
    from twogifs import app
    app.run(debug=True)


if __name__ == "__main__":
    main()
