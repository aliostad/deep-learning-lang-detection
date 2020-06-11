#!/usr/bin/bash
# -*- coding: utf-8 -*-

def my_append_list(l, e):
    "Simuliert die Append-Methode. Hängt e an l an."
    l[len(l):] = [e]
    return l

def my_append_string(s, e):
    "Simuliert die Append-Methode. Hängt e an s an."
    s += e
    return s

def my_append_tuple(t, e):
    "Simuliert die Append-Methode. Hängt e an t an."
    t += (e,)
    return t

# Liste
l = ["a", "b", "c"]
l = my_append(l, "d")
print l

# String
s = "abcde"
s = my_append_string(s, "f")
print s

# Tupel
t = (1, 2, 3)
t = my_append_tuple(t, 4)
print t
