from helio.settings import DEFAULT_ROOT_COMPONENT
from helio.controller.helpers import init_controller
from helio.helio_exceptions import ViewStateError


def split_and_validate_path(path):
    split_path = path.split('.')

    if '' in split_path:
        raise ValueError("Path may not contain empty components.")

    if split_path[0] != 'page':
        raise ValueError("The root controller must be 'page'")

    return split_path


class ViewState(object):
    def __init__(self, root_controller):
        self.root_controller = root_controller
        root_controller.make_root(self)

    def controller_from_path(self, path):
        split_path = split_and_validate_path(path)

        if path == 'page':
            return self.root_controller

        controller = self.root_controller

        for path_component in split_path[1:]:
            controller = controller.get_child(path_component)

        return controller

    def post_setup(self):
        self.root_controller._post_attach()

    def _add_controller_to_parent(self, parent_controller, controller, child_key, is_push):
        if is_push:
            parent_controller.push_child(child_key, controller)
        else:
            parent_controller.set_child(child_key, controller)

    def _parent_controller_and_child_key_from_path(self, path):
        split_path = split_and_validate_path(path)

        if len(split_path) < 2:
            raise ValueError('To retrieve a parent controller, path must have at least two components.')

        parent_controller = self.controller_from_path('.'.join(split_path[:-1]))
        return parent_controller, split_path[-1]

    def insert_controller(self, path, controller):
        """
        Inserts an already initialised controller at the given path.
        Will replace the stack of controllers already at the path, with a new stack,
        containing just this controller.
        """
        parent_controller, child_key = self._parent_controller_and_child_key_from_path(path)
        self._add_controller_to_parent(parent_controller, controller, child_key, False)

    def insert_new_controller(self, path, component_name, *args, **kwargs):
        """
        Similar to the insert_controller method, however it takes a component name
        and arguments and will init the controller before inserting it at the given path,
        replacing the existing controller stack with a new stack containing just this
        controller.
        """
        controller = init_controller(component_name, *args, **kwargs)
        self.insert_controller(path, controller)
        return controller

    def push_controller(self, path, controller):
        """
        Pushes and already initialised controller onto the stack at the given path.
        """
        parent_controller, child_key = self._parent_controller_and_child_key_from_path(path)
        self._add_controller_to_parent(parent_controller, controller, child_key, True)

    def push_new_controller(self, path, component_name, *args, **kwargs):
        """
        Similar to the push_controller method, however it takes a component name
        and arguments and will init the controller before pushing it onto the given path.
        """
        controller = init_controller(component_name, *args, **kwargs)
        self.push_controller(path, controller)
        return controller

    def pop_controller(self, path):
        """Pop a controller from the stack at the given path."""
        parent_controller, child_key = self._parent_controller_and_child_key_from_path(path)
        return parent_controller.pop_child(child_key)


class ViewStateManager(object):
    def __init__(self):
        self._state_store = []

    def get_view_state(self, index, no_create=False):
        index = None if index < 0 else index

        try:
            view_state = self._state_store[index]
        except (IndexError, TypeError):
            if no_create:
                raise ViewStateError("ViewState does not exist at index %s" % index)
            view_state = get_default_viewstate()
            self._state_store.append(view_state)
            view_state.index = len(self._state_store) - 1

        return view_state


def get_default_viewstate():
    from notification import NotificationCentre
    root = init_controller(DEFAULT_ROOT_COMPONENT)
    vs = ViewState(root)
    NotificationCentre(vs)
    vs.post_setup()
    return vs
