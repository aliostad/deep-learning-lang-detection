require 'savon'

# module mixins
require_relative 'csi_api/add_attr_accessor'
require_relative 'csi_api/extract_attributes'
require_relative 'csi_api/group_ex_class_shared_methods'
require_relative 'csi_api/check_soap_response'

# classes
require_relative 'csi_api/client_factory'
require_relative 'csi_api/csi_client'
require_relative 'csi_api/list_generator'
require_relative 'csi_api/employee'
require_relative 'csi_api/member'
require_relative 'csi_api/mocks/savon_response'
require_relative 'csi_api/group_ex_class_list'
require_relative 'csi_api/group_ex_class'
require_relative 'csi_api/equipment'
require_relative 'csi_api/reservation'
require_relative 'csi_api/reservation_list'
require_relative 'csi_api/cart_item'
