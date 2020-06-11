# coding=utf-8
import re


class ControllerState:
    """
    控制器管理状态的基类
    """

    @staticmethod
    def alpha(controller, ch):
        pass

    @staticmethod
    def punctuation(controller, p):
        pass

    @staticmethod
    def enter(controller):
        pass

    @staticmethod
    def backspace(controller):
        pass

    @staticmethod
    def c_l(controller):
        pass

    @staticmethod
    def tab(controller):
        pass

    @staticmethod
    def esc(controller):
        pass

    @staticmethod
    def c_p(controller):
        pass

    @staticmethod
    def c_n(controller):
        pass

    @staticmethod
    def recover(controller):
        raise NotImplementedError

    @staticmethod
    def c_k(controller):
        pass


class WordInput(ControllerState):
    """
    查询状态下的各种操作处理
    """

    en_chars = r'[a-zA-Z]'

    @staticmethod
    def _update_relevant(controller):
        """
        根据目前输入的单词刷新补全单词
        根据补全单词更新显示
        更新选中单词的下标
        """
        controller.set_relevant(controller.trie.get_relevant(controller.input_word))
        controller.cn_last = controller.search_window.show_relevant(controller.relevant_words, 0)
        controller.selected_index = 0

    @staticmethod
    def _search_en_word(controller):
        if controller.relevant_words and controller.relevant_words[0] == controller.input_word:
            explained_word = controller.local_dict.get_meaning(controller.input_word)
        else:
            explained_word = controller.online_dict.get_en_word_meaning(controller.input_word)
        return explained_word

    @staticmethod
    def _search_zh_word(controller):
        explained_word = controller.online_dict.get_zh_word_meaning(controller.input_word)
        return explained_word

    @staticmethod
    def alpha(controller, ch):
        """
        输入字母时刷新字符串
        """
        # 忽略首字符时空格的输入
        if ch == ' ' and len(controller.input_word) == 0:
            controller.change_to_state(WordDisplay)
        # 保证输入长度合法
        elif len(controller.input_word) < controller.word_max_length:
            controller.input_word += ch
            controller.search_window.show_input_word(controller.input_word)
            WordInput._update_relevant(controller)

    @staticmethod
    def enter(controller):
        """
        查询单词，隐藏查询框
        切换到展示状态并展示单词内容
        """
        has_en_char = re.search(WordInput.en_chars, controller.input_word)
        controller.word_meanings_window.clear()
        if has_en_char:
            explained_word = WordInput._search_en_word(controller)
            controller.word_meanings_window.display_en_word(explained_word)
        else:
            explained_word = WordInput._search_zh_word(controller)
            controller.word_meanings_window.display_zh_word(explained_word)
        # 清空单词
        controller.input_word = str()
        controller.change_to_state(WordDisplay)

    @staticmethod
    def backspace(controller):
        """
        删除最后一个字母，刷新字符串
        """
        controller.input_word = controller.input_word[:-1]
        if len(controller.input_word) == 0:
            controller.change_to_state(WordDisplay)
        else:
            controller.search_window.show_input_word(controller.input_word)
            WordInput._update_relevant(controller)

    @staticmethod
    def c_l(controller):
        """
        删除全部输入
        """
        controller.input_word = str()
        controller.change_to_state(WordDisplay)

    @staticmethod
    def tab(controller):
        """
        通过当前高亮的单词补全输入单词
        """
        if len(controller.relevant_words) != 0:
            controller.input_word = controller.relevant_words[controller.selected_index]
            controller.search_window.show_input_word(controller.input_word)
            WordInput._update_relevant(controller)

    @staticmethod
    def esc(controller):
        """
        隐藏查询窗口，删除已输入的单词
        """
        controller.input_word = str()
        controller.change_to_state(WordDisplay)

    @staticmethod
    def c_p(controller):
        """
        候选高亮位置向上移动，如果在顶端则移到低端
        """
        if controller.selected_index == 0:
            controller.selected_index = controller.cn_last
        elif controller.selected_index >= 1:
            controller.selected_index -= 1

        controller.search_window.show_relevant(controller.relevant_words,
                                               controller.selected_index)

    @staticmethod
    def c_n(controller):
        """
        候选高亮位置向下移动，如果在底端则移到顶端
        """
        if controller.selected_index == controller.cn_last:
            controller.selected_index = 0
        elif controller.selected_index < controller.cn_last:
            controller.selected_index += 1

        controller.search_window.show_relevant(controller.relevant_words,
                                               controller.selected_index)

    @staticmethod
    def recover(controller):
        """
        恢复查询状态原本的内容
        """
        controller.search_window.recover()

    @staticmethod
    def c_k(controller):
        """
        进入翻译状态
        """
        controller.input_word = str()
        controller.relevant_words = None
        controller.fix_background()
        controller.change_to_state(Translate)


class WordDisplay(ControllerState):
    """
    展示状态下的各种操作处理
    """

    @staticmethod
    def alpha(controller, ch):
        """
        切换到查询状态
        """
        controller.change_to_state(WordInput)
        controller.state.alpha(controller, ch)

    @staticmethod
    def esc(controller):
        """
        退出程序
        """
        raise StopIteration()

    @staticmethod
    def recover(controller):
        """
        恢复展示状态原来的内容
        """
        controller.fix_background()
        controller.word_meanings_window.recover()

    @staticmethod
    def c_k(controller):
        """
        进入翻译状态
        """
        controller.change_to_state(Translate)


class Translate(ControllerState):

    @staticmethod
    def recover(controller):
        controller.fix_background()
        controller.translation_window.recover()

    @staticmethod
    def alpha(controller, ch):
        if ch == ' ' and len(controller.input_sentence) == 0:
            return
        controller.input_sentence += ch
        controller.translation_window.show_input(controller.input_sentence)

    @staticmethod
    def punctuation(controller, p):
        controller.input_sentence += p
        controller.translation_window.show_input(controller.input_sentence)

    @staticmethod
    def esc(controller):
        controller.change_to_state(WordDisplay)

    @staticmethod
    def c_k(controller):
        controller.change_to_state(WordDisplay)

    @staticmethod
    def backspace(controller):
        controller.input_sentence = controller.input_sentence[:-1]
        controller.translation_window.show_input(controller.input_sentence)

    @staticmethod
    def c_l(controller):
        controller.input_sentence = str()
        controller.translation_window.show_input(controller.input_sentence)

    @staticmethod
    def enter(controller):
        translate_result = controller.translator.translate(controller.input_sentence)
        if translate_result is not None:
            controller.translation_window.show_result(translate_result)