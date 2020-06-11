#!/usr/bin/env bash

. test.sh

given=assets/outputs/1.out.$$
expect=assets/outputs/1.out

sample "web-app.servlet.servlet-name" servlet.json
sample "web-app.*.servlet-name" servlet.json
sample "web-app" servlet.json
sample "\t" servlet.json
sample "web-app.servlet.*" servlet.json

sample "simple" simple.json
sample "simple.bla.*" simple.json
sample "simple.*.bla" simple.json

sample "widget.debug" widgets.json
sample "widget.deb" widgets.json
sample "*" widgets.json
sample "" widgets.json
sample "widget.*.name" widgets.json
sample "widget.window.name" widgets.json
sample "widget.window.na" widgets.json

sample "name" donuts.json

assert
