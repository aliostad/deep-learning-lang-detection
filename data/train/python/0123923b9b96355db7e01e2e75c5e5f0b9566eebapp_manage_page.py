#-*- coding: UTF-8 -*-  

import sys
import time
from common.py_common_keyword.CommonFunctions import CommonFunctions
from selenium.webdriver.common.by import By
from startOperate import startOperate

 
class app_manage_page():
    '''
                             版本 应用商店4.0.1
                             编号 AppStore2-909
                            标题    管理界面验证
        '''
    def __init__(self):
        self.common_fn = CommonFunctions()
      
    def manage_page(self):
        try:
            manage_buttons=self.common_fn.wait_for_elements(r'com.tclmarket:id/text',By.ID)
            manage_button_num=self.common_fn.wait_for_element(r'com.tclmarket:id/manager_update_app_tips')
            manage_num=manage_button_num.text
            print manage_num
            if manage_buttons[4].text==u'管理':
                manage_buttons[4].click()
                time.sleep(2)
                print u'go into manage page\n'
            else:
                print u'manage_button[4].text do not equal to 管理' 
                
            try:
                action_texts=self.common_fn.wait_for_elements(r'com.tclmarket:id/manage_text',By.ID)
                for i in range(5):
                    print action_texts[i].text
                print u'manage page is right\n'
                try:            
                    action_buttons=self.common_fn.wait_for_elements(r'com.tclmarket:id/manage_image',By.ID)
                    action_buttons[1].click()
                    time.sleep(2)
                    try:
                        updated_titles=self.common_fn.wait_for_elements('com.tclmarket:id/header_text',By.ID)
                        if updated_titles:
                            print updated_titles[0].text
                            print manage_num
                            manage_num_str=u'可更新（'+manage_num+u'）'
                            if updated_titles[0].text==manage_num_str:
                                print u'the number of apps to be updated is right\n'
                                return True
                        else:
                            print u'no app to be updated\n' 
                            return True
                    except Exception as e:
                        print u'error 3:'+e
                        print u'can not get number of updated_title \n'
                        return False
                except Exception as e:
                    print u'error 2:'+e
                    print u'action_buttons are wrong\n'    
                    return False
            except Exception as e:
                print u'error 1:'+e
                print u'fail to go into download task page'  
                return False
        except Exception as e:
            print e
            print u'not find manage button\n'
            s = sys.exc_info()
            print 'Error %s on line %d' % (s[1],s[2].tb_lineno)
            return False
        finally:
            self.common_fn.driver.remove_app('com.tencent.qqlive')        
                
    def run(self):
        start = startOperate()
        return self.common_fn.run_test_case(lambda: self.common_fn.launch_app('4.0.1'),
                                     lambda: start.baseOperate(),
                                     lambda: self.manage_page())        
    
if __name__ =="__main__":
    test=app_manage_page()
    test.run()

                                
                                           
     
