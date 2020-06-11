def build_create_parser(dispatch, action_parser, help=''):
    if not help:
        help = "Create a(n) {0} record".format(dispatch.dtype)
    create_parser = action_parser.add_parser('create', help=help)
    for add_arg, extract_arg, test_method in dispatch.create_args:
        add_arg(create_parser)


def build_update_parser(dispatch, action_parser, help=''):
    if not help:
        help = "Update a(n) {0}".format(dispatch.dtype)
    update_parser = action_parser.add_parser('update', help=help)
    for add_arg, extract_arg, test_method in dispatch.update_args:
        add_arg(update_parser, required=False)


def build_delete_parser(dispatch, action_parser, help=''):
    if not help:
        help = "Delete a(n) {0}".format(dispatch.dtype)
    delete_parser = action_parser.add_parser('delete', help=help)
    for add_arg, extract_arg, test_method in dispatch.delete_args:
        add_arg(delete_parser)


def build_detail_parser(dispatch, action_parser, help=''):
    if not help:
        help = "Detail a(n) {0}".format(dispatch.dtype)
    detail_parser = action_parser.add_parser('detail', help=help)
    for add_arg, extract_arg, test_method in dispatch.detail_args:
        add_arg(detail_parser)
