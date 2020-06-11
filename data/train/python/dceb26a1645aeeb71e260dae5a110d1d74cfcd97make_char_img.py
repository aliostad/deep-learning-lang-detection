#!/home/kohei/.pyenv/shims/python
# -*- encoding: utf-8 -*-
import sys
sys.path.append('..')

import kdebug
from kimage import *
from kfont import get_word_image

if(len(sys.argv) <= 1):
    print "no save object: all, ascii"
    sys.exit(1)
SAVE_OBJECT = sys.argv[1]

if(len(sys.argv) <= 2):
    print "no save directory"
    sys.exit(1)
SAVE_DIR = sys.argv[2]

def cut(image):
    l = -1 
    r = -1 
    l = -1 
    d = -1 
    for i in range(image.size[0]):
        if(not is_vline(image, i, 0)):
            l = i
            break
    for i in range(image.size[0]-1, -1, -1):
        if(not is_vline(image, i, 0)):
            r = i+1
            break
    for i in range(image.size[1]):
        if(not is_hline(image, i, 0)):
            u = i
            break
    for i in range(image.size[1]-1, -1, -1):
        if(not is_hline(image, i, 0)):
            d = i+1
            break

    if(l == -1):
        return image
    return image.crop((l,u,r,d))

def save_at(i):
    ch = unichr(i)
    print(u"{0}:[{1}]".format(hex(i), ch))
    image = get_word_image(ch)
    barray = g_to_barray(image.getdata())
    gimg = Image.new("L", image.size)
    gimg.putdata(b_to_garray(barray))
    gimg = cut(gimg).resize((20,20))
    name = "{0:0>4}".format(hex(i)[2:].upper())
    gimg.save(SAVE_DIR + "/{0}.png".format(name))

def save_range(start, end):
    for i in range(start, end + 1):
        save_at(i)

zenkaku_symbol_list = [
        u"、",
        u"。",
        u"？",
#        u"・",
        u"「",
        u"」",
        u"『",
        u"』",
        u"○",
        u"ー",
        u"＆",
        u"％",
        u"＃",
        u"＄",
        u"！",
        u"＊",
        u"＝",
        u"＋",
        ]

zenkaku_kanji_list = [
        u"門",
        u"鮎",
        u"安",
        u"井",
        u"戸",
        u"右", u"左", u"上", u"下",
        u"鳥",
        u"白", u"赤", u"青", u"黒", u"黄",
        u"色",
        u"永",
        u"駅",
        u"王",
        u"化",
        u"口", u"因", u"国",
        u"日", u"年", u"月",
        u"花", u"草",
        u"海", u"湖",
        u"外",
        u"本",
        u"学",
        u"甘",
        u"辛",
        u"丸",
        u"二", u"三", u"四", u"五", u"六", u"七", u"八", u"九", u"十",
        u"百", u"千", u"万", u"億",
        u"曲",
        u"犬", u"猫",
        u"野", u"球",
        u"見",
        u"工",
        u"作",
        u"子",
        u"親",
        u"次",
        u"人",
        u"中",
        u"何",
        u"夏", u"秋", u"冬", u"春",
        u"朝", u"昼", u"夜",
        u"東", u"西", u"南", u"北",
        u"文",
        u"漫", u"画", u"映",
        u"英", u"語",
        u"呼",
        u"表",
        u"動", u"虫", u"物",
        ]

zenkaku_kana_list = [
        u"あ", u"い", u"う", u"え", u"お",
        u"か", u"き", u"く", u"け", u"こ",
        u"さ", u"し", u"す", u"せ", u"そ",
        u"た", u"ち", u"つ", u"て", u"と",
        u"な", u"に", u"ぬ", u"ね", u"の",
        u"は", u"ひ", u"ふ", u"へ", u"ほ",
        u"ま", u"み", u"む", u"め", u"も",
        u"や", u"ゆ", u"よ",
        u"ゃ", u"ゅ", u"ょ",
        u"ら", u"り", u"る", u"れ", u"ろ",
        u"わ", u"を", u"ん",

        u"ア", u"イ", u"ウ", u"エ", u"オ",
        u"カ", u"キ", u"ク", u"ケ", u"コ",
        u"サ", u"シ", u"ス", u"セ", u"ソ",
        u"タ", u"チ", u"ツ", u"テ", u"ト",
        u"ナ", u"ニ", u"ヌ", u"ネ", u"ノ",
        u"ハ", u"ヒ", u"フ", u"ヘ", u"ホ",
        u"マ", u"ミ", u"ム", u"メ", u"モ",
        u"ヤ", u"ユ", u"ヨ",
        u"ャ", u"ュ", u"ョ",
        u"ラ", u"リ", u"ル", u"レ", u"ロ",
        u"ワ", u"ヲ", u"ン",

        ]

def save_zenkaku():
    for ch in zenkaku_symbol_list:
        save_at(ord(ch))
    save_range(0x3041, 0x3093) # save hiragana
    save_range(0x30A1, 0x30F6) # save katakana
    for ch in zenkaku_kanji_list:
        save_at(ord(ch))

def save_ascii():
#    save_range(0x0020, 0x007D) # all ascii codes
    save_range(0x0030, 0x0039) # number
    save_range(0x0041, 0x005A) # alphabets upper
    save_range(0x0061, 0x007A) # alphabets lower 

if(SAVE_OBJECT == "ascii"):
    save_ascii()
if(SAVE_OBJECT == "zenkaku"):
    save_zenkaku()
if(SAVE_OBJECT == "all"):
    save_zenkaku()
#    save_ascii()





