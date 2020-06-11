from contextlib import contextmanager
import nose
from pysics import *

@contextmanager
def manage_world():
    world = World((0, 0), True)
    yield world

@contextmanager
def manage_static_body(world, *args, **kwargs):
    body = world.create_static_body(*args, **kwargs)
    yield body
    world.destroy_body(body)

@contextmanager
def manage_kinematic_body(world, *args, **kwargs):
    body = world.create_kinematic_body(*args, **kwargs)
    yield body
    world.destroy_body(body)

@contextmanager
def manage_dynamic_body(world, *args, **kwargs):
    body = world.create_dynamic_body(*args, **kwargs)
    yield body
    world.destroy_body(body)

@contextmanager
def manage_circle_fixture(body, *args, **kwargs):
    fixture = body.create_circle_fixture(*args, **kwargs)
    yield fixture
    body.destroy_fixture(fixture)

@contextmanager
def manage_edge_fixture(body, *args, **kwargs):
    fixture = body.create_edge_fixture(*args, **kwargs)
    yield fixture
    body.destroy_fixture(fixture)

@contextmanager
def manage_polygon_fixture(body, *args, **kwargs):
    fixture = body.create_polygon_fixture(*args, **kwargs)
    yield fixture
    body.destroy_fixture(fixture)

@contextmanager
def manage_loop_fixture(body, *args, **kwargs):
    vertex_array = VertexArray()
    fixture = body.create_loop_fixture(vertex_array, *args, **kwargs)
    yield fixture
    body.destroy_fixture(fixture)

@contextmanager
def manage_revolute_joint(world, *args, **kwargs):
    revolute_joint = world.create_revolute_joint(*args, **kwargs)
    yield revolute_joint
    world.destroy_joint(revolute_joint)

@contextmanager
def manage_prismatic_joint(world, *args, **kwargs):
    prismatic_joint = world.create_prismatic_joint(*args, **kwargs)
    yield prismatic_joint
    world.destroy_joint(prismatic_joint)

@contextmanager
def manage_distance_joint(world, *args, **kwargs):
    distance_joint = world.create_distance_joint(*args, **kwargs)
    yield distance_joint
    world.destroy_joint(distance_joint)

def test_exercise():
    with manage_world() as world:
        with manage_dynamic_body(world) as body:
            with manage_circle_fixture(body) as fixture:
                pass
            with manage_edge_fixture(body) as fixture:
                pass
            with manage_polygon_fixture(body) as fixture:
                pass
            with manage_loop_fixture(body) as fixture:
                pass

def test_create_revolute_joint():
    with manage_world() as world:
        with manage_static_body(world) as body_a:
            with manage_dynamic_body(world) as body_b:
                with manage_revolute_joint(world, body_a, body_b, (0, 0)) as revolute_joint:
                    pass

def test_create_prismatic_joint():
    with manage_world() as world:
        with manage_static_body(world) as body_a:
            with manage_dynamic_body(world) as body_b:
                with manage_prismatic_joint(world, body_a, body_b, (0, 0), (0, 0)) as prismatic_joint:
                    pass

def test_create_distance_joint():
    with manage_world() as world:
        with manage_static_body(world) as body_a:
            with manage_dynamic_body(world) as body_b:
                with manage_distance_joint(world, body_a, body_b, (0, 0), (0, 0)) as distance_joint:
                    pass

def _test_identity(a, b):
    assert a is not b
    assert id(a) != id(b)
    assert a == b
    assert not a != b
    assert hash(a) == hash(b)

def test_body_identity():
    with manage_world() as world:
        with manage_dynamic_body(world):
            _test_identity(world.bodies[0], world.bodies[0])

def test_fixture_identity():
    with manage_world() as world:
        with manage_dynamic_body(world) as body:
            with manage_circle_fixture(body):
                _test_identity(body.fixtures[0], body.fixtures[0])

def test_joint_identity():
    with manage_world() as world:
        with manage_static_body(world) as body_a:
            with manage_dynamic_body(world) as body_b:
                with manage_revolute_joint(world, body_a, body_b, (0, 0)):
                    _test_identity(body_a.joints[0], body_b.joints[0])

if __name__ == '__main__':
    nose.main()
