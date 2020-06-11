import logging
from flask import Flask, render_template
from controller import Controller

logging.basicConfig(level=logging.DEBUG,
                    format='%(asctime)s %(levelname)s\t(%(threadName)-10s) %(filename)s:%(lineno)d\t%(message)s')

app = Flask(__name__)
controller = Controller()


@app.route("/")
def hello():
    return render_template('form.html', **build_constants())


@app.route("/<code>")
def move(code):
    logging.debug('processing: %s' % code)
    try:
        c = int(code)
        controller.process(c)
    except ValueError:
        pass
    return render_template('form.html', **build_constants())


def build_constants():
    map = {
        'move_forward': Controller.MOVE_FORWARD,
        'move_backward': Controller.MOVE_BACKWARD,
        'turn_left': Controller.TURN_LEFT,
        'turn_right': Controller.TURN_RIGHT,
        'head_left': Controller.HEAD_LEFT,
        'head_right': controller.HEAD_RIGHT,
        'left_arm_up': Controller.LEFT_ARM_UP,
        'left_arm_down': controller.LEFT_ARM_DOWN,
        'right_arm_up': Controller.RIGHT_ARM_UP,
        'right_arm_down': controller.RIGHT_ARM_DOWN,
        'sound_1': controller.SOUND_1,
        'sound_2': controller.SOUND_2
    }
    return map


if __name__ == "__main__":
    try:
        app.run(host="0.0.0.0", port=80, debug=True)
    except KeyboardInterrupt:
        controller.__del__()
