  #encoding: utf-8
  require 'selenium-webdriver'

  dr = Selenium::WebDriver.for :chrome
  url = 'http://www.baidu.com'
  dr.get url

  p dr.manage.all_cookies
  dr.manage.delete_all_cookies
  dr.manage.add_cookie(name: 'BAIDUID', value: '0173F00E405FDBFA6CAD5C03EA730B81:FG=1')
  dr.manage.add_cookie(name: 'BDUSS', value: '3N0RG5IaEZRc1k1WGg0ZUQ3LVoxSkZjR3FSVHhyckt4WU5-YVgzb1FCLTVafmRSQVFBQUFBJCQAAAAAAAAAAAEAAABvHwcBaHl6czI1AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALnaz1G52s9Rb')

  # 重新访问该页面就可以发现已经登陆了
  # 当然也可以刷新该页面
  dr.get url

  sleep(3)
  dr.quit()