import time
from move import controller


def set_color(red, green, blue):
    controller.set_color(red, green, blue)


if __name__ == "__main__":
    controller.on_btn_triangle(set_color, 0, 255, 0)
    controller.on_btn_triangle_release(set_color, 0, 0, 0)

    controller.on_btn_circle(set_color, 255, 0, 0)
    controller.on_btn_circle_release(set_color, 0, 0, 0)

    controller.on_btn_cross(set_color, 0, 0, 255)
    controller.on_btn_cross_release(set_color, 0, 0, 0)

    controller.on_btn_square(set_color, 255, 105, 180)
    controller.on_btn_square_release(set_color, 0, 0, 0)

    controller.on_btn_move(set_color, 255, 255, 255)
    controller.on_btn_move_release(set_color, 0, 0, 0)

    while True:
        time.sleep(1)
