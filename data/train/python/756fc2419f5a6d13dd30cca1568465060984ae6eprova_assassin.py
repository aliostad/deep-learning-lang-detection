#!/usr/bin/env python
#coding=utf-8

from __future__ import division, print_function
from Assassin import * 
from random import shuffle

assassins_dictionary = eval(open("assassins_db_prova.dat").read())
l = AssassinList()
shuffled_list = assassins_dictionary.keys()
shuffle(shuffled_list)
for name in shuffled_list:
    l.append(Assassin(name, assassins_dictionary[name]))


i = l.index(Assassin("Matteo Abis", assassins_dictionary["Matteo Abis"]))

l.save("prova_save.txt")

print(open("prova_save.txt").read())

print(l)
del l[i]

l.save("prova_save.txt")
l.load("prova_save.txt")
print(l)
