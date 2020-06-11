#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

import time
import unittest
import json
from nose_parameterized import parameterized
from selenium.webdriver import Firefox
from selenium.webdriver.support.ui import Select

from controller import Controller
from data import from_csv, Bonus


class KaskoCalcTestCase(unittest.TestCase):
    config = json.load(open("config.json"))
    controller = None

    @staticmethod
    def wait(condition_function, timeout=60):
        attempts = 0
        while condition_function() and attempts < timeout:
            time.sleep(1)
            attempts += 1

    @classmethod
    def setUpClass(cls):
        cls.controller = Controller(Firefox())
        cls.controller.driver.maximize_window()
        cls.controller.driver.get(cls.config["url"])
        with open(cls.config["output"], 'w') as fd:
            fd.write("Марка,Модель,Год,Цена,Только ущерб (без угона),Угон (без ключей) + ущерб\n")

    @classmethod
    def tearDownClass(cls):
        cls.controller.driver.close()

    @parameterized.expand(from_csv(config["input"]))
    def test(self, car):

        self.controller.option(self.controller.car_brand, car.brand).click()
        time.sleep(3)
        # self.wait(lambda: len(Select(self.controller.car_model).options) == 1)
        self.controller.option(self.controller.car_model, car.model).click()
        self.controller.option(self.controller.car_year, str(car.year)).click()
        self.controller.car_price.clear()
        self.controller.car_price.send_keys(car.price)
        self.controller.car_usage_date.clear()
        self.controller.car_usage_date.send_keys("01.01.{0}".format(car.year))
        self.controller.option(self.controller.car_horse_power, "201 и более").click()
        self.controller.new_car.click() if car.year == 2014 else self.controller.old_car.click()
        self.controller.no_credit.click()
        self.controller.auto_start_no.click()
        self.controller.closed_list.click()
        self.controller.driver_age.clear()
        self.controller.driver_age.send_keys(30)
        self.controller.driver_experience.clear()
        self.controller.driver_experience.send_keys(10)
        self.controller.option(self.controller.driver_sex, "Мужской").click()
        self.controller.option(self.controller.driver_marital_status, "Состою в браке").click()
        self.controller.option(self.controller.driver_children, "Есть").click()
        self.controller.option(self.controller.insurance_period, "1 год").click()
        self.controller.variable_insured_sum.click()
        self.controller.no_franchise.click()
        self.controller.last_name.clear()
        self.controller.last_name.send_keys(u"Фамилия")
        self.controller.first_name.clear()
        self.controller.first_name.send_keys(u"Имя")
        self.controller.patronymic.clear()
        self.controller.patronymic.send_keys(u"Отчество")
        self.controller.age.clear()
        self.controller.age.send_keys(30)
        self.controller.phone_code.clear()
        self.controller.phone_code.send_keys(u"999")
        self.controller.phone_number.clear()
        self.controller.phone_number.send_keys(u"9999999")
        self.controller.email.clear()
        self.controller.email.send_keys(u"1@example.com")

        self.controller.calculate.click()
        self.wait(self.controller.calculate_loading.is_displayed)

        self.controller.only_damage.click()
        self.wait(self.controller.loading.is_displayed)

        bonus = Bonus(risk="Только ущерб (без угона)")
        self.controller.optimal.click()
        bonus.optimal = self.controller.result_cost.text.encode('utf-8')
        self.controller.premium.click()
        bonus.premium = self.controller.result_cost.text.encode('utf-8')
        self.controller.platinum.click()
        bonus.platinum = self.controller.result_cost.text.encode('utf-8')
        car.results.append(bonus)

        self.controller.driving_away_without_keys_plus_damage.click()
        self.wait(self.controller.loading.is_displayed)

        bonus = Bonus(risk="Угон (без ключей) + ущерб")
        self.controller.optimal.click()
        bonus.optimal = self.controller.result_cost.text.encode('utf-8')
        self.controller.premium.click()
        bonus.premium = self.controller.result_cost.text.encode('utf-8')
        self.controller.platinum.click()
        bonus.platinum = self.controller.result_cost.text.encode('utf-8')
        car.results.append(bonus)

        with open(self.config["output"], 'a') as fd:
            fd.write('{0}\n'.format(car))
