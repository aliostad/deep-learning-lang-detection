__author__ = 'Hao Lin'

import sys
import getopt
from ingest_controller import IngestController
from controllers.main_controller import MainController


def main(argv):
    partner_str = ""
    process = ""
    try:
        opts, args = getopt.getopt(argv, "p:r:", ["partner=", "process="])
    except getopt.GetoptError:
        print "Wrong syntax or parameter."
        sys.exit(2)

    for opt, arg in opts:
        if opt in ("-p", "--partner"):
            partner_str = arg
        elif opt in ("-r", "--process"):
            process = arg

    # Set partner
    if partner_str.isdigit():
        partner = MainController.set_partner(int(partner_str))
    else:
        partner = MainController.set_partner(partner_str)

    controller = IngestController(partner, process)


    controller.import_metadata()

if __name__ == "__main__":
    main(sys.argv[1:])
