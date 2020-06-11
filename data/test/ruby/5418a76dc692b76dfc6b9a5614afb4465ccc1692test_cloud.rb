# encoding: utf-8
require File.dirname(__FILE__) + '/case_suit/suit_node_manage'

module ZDDI
    Node_manage = ZDDI::Cloud::Node_manage.new

    def node_manage_suit # ( 22/63 )
        r = []
        r << Node_manage.case_696(:args=>'nil') # 参数校验
        r << Node_manage.case_786(:args=>'nil') # 参数校验
        r << Node_manage.case_774(:args=>'nil') # 参数校验
        r << Node_manage.case_775(:args=>'nil') # 参数校验
        r << Node_manage.case_776(:args=>'nil') # 参数校验
        r << Node_manage.case_778(:args=>'nil') # 参数校验
        r << Node_manage.case_779(:args=>'nil') # 参数校验
        r << Node_manage.case_780(:args=>'nil') # 参数校验
        r << Node_manage.case_781(:args=>'nil') # 参数校验
        r << Node_manage.case_782(:args=>'nil') # 参数校验
        r << Node_manage.case_783(:args=>'nil') # 参数校验
        r << Node_manage.case_772(:args=>'nil') # 参数校验
        r << Node_manage.case_773(:args=>'nil') # 参数校验
        r << Node_manage.case_769(:args=>'nil') # 添加设备无法识别-gzw
        r << Node_manage.case_770(:args=>'nil') # 无法识别的ZDNS设备-gzw
        r << Node_manage.case_767(:args=>'nil') # 添加重复设备节点，IP地址已存在-gzw
        r << Node_manage.case_766(:args=>'nil') # 新建设备，设备名称已存在-gzw
        r << Node_manage.case_798(:args=>'nil') # 编辑设备名称输入格式错误-gzw
        r << Node_manage.case_797(:args=>'nil') # 设备名称输入为空-gzw  
        r << Node_manage.case_8343(:args=>'nil') # 删除设备后再重新添加该设备-gzw  
        r << Node_manage.case_784(:args=>'nil') # 添加设备用户名错误-gzw  
        r << Node_manage.case_785(:args=>'nil') # 添加设备密码错误-gzw  
    end
end