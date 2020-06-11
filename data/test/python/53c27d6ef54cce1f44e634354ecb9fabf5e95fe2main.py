from store.controller.QuestionController import QuestionController
from store.controller.QuizController import QuizController
from store.domain.QuestionValidator import QuestionValidator
from store.domain.QuizValidator import QuizValidator
from store.domain.validators import Validator
from store.repository.QuestionRepository import QuestionRepository
from store.repository.QuizRepository import QuizRepository
from store.ui.Console import Console

__author__ = 'victor'


class Application(object):
    @classmethod
    def run(cls):
        quiz_repo = QuizRepository(QuizValidator(), "quizes.txt")
        question_repo = QuestionRepository(QuestionValidator(), "questions.txt")

        quiz_ctrl = QuizController(quiz_repo)
        question_ctrl = QuestionController(question_repo)

        console = Console(quiz_ctrl, question_ctrl)
        console.run()

if __name__ == '__main__':
    Application.run()