# -*- coding: utf-8 -*-

import unittest

from selenium import webdriver
from .my_broker_helper import MyBrokerHelper


class MyBrokerAuthenticationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        print("")
        print("[SUITE]: {0}".format(cls.__name__))

    def setUp(self):
        print("")
        print(" [TEST]: {0}".format(self._testMethodName))

        self.driver = webdriver.Firefox()
        self.driver.implicitly_wait(10)
        self.base_url = "https://old.broker.ru/"
        self.verificationErrors = []
        self.accept_next_alert = True

    def test_try_auth_with_wrong_email(self):
        MyBrokerHelper.openPage(self.driver, self.base_url)

        self.assertEqual(self.driver.current_url, "https://my.broker.ru/")

        form = MyBrokerHelper.getForm(self.driver)

        self.assertEqual(form.email.get_attribute("class"), "form-control")

        MyBrokerHelper.submitForm(form, [ "Andrew 01", "1111111111", "mail" ])

        self.assertEqual(form.email.get_attribute("class"), "form-control _error")

    def test_try_auth_with_empty_name(self):
        MyBrokerHelper.openPage(self.driver, self.base_url)

        self.assertEqual(self.driver.current_url, "https://my.broker.ru/")

        form = MyBrokerHelper.getForm(self.driver)

        self.assertEqual(form.name.get_attribute("class"), "form-control")

        MyBrokerHelper.submitForm(form, ["", "1111111111", "mail@mail.ru"])

        self.assertEqual(form.name.get_attribute("class"), "form-control _error")

    def test_try_auth_with_wrong_phone(self):
        MyBrokerHelper.openPage(self.driver, self.base_url)

        self.assertEqual(self.driver.current_url, "https://my.broker.ru/")

        form = MyBrokerHelper.getForm(self.driver)

        self.assertEqual(form.phone.get_attribute("class"), "form-control js-feedback-phone")

        MyBrokerHelper.submitForm(form, ["Login A_1", "BBBAAASSDD", "mail@mail.ru"])

        self.assertEqual(form.phone.get_attribute("class"), "form-control js-feedback-phone _error")

    def test_try_auth_with_name_like(self):
        MyBrokerHelper.openPage(self.driver, self.base_url)

        self.assertEqual(self.driver.current_url, "https://my.broker.ru/")

        form = MyBrokerHelper.getForm(self.driver)

        self.assertEqual(form.name.get_attribute("class"), "form-control")

        MyBrokerHelper.submitForm(form, ["%%%/%%%", "1111111111", "mail@mail.ru"])

        self.assertEqual(form.name.get_attribute("class"), "form-control")



    def tearDown(self):
        self.driver.close()
        self.assertEqual([], self.verificationErrors)
