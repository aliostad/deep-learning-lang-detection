#####################################################################
# Project:    A*HRM
# Title:     URL patterns 
# Version:     0001
# Last-Modified:     2009-02-26 05:36:39  (Thu, 26 April 2009)        
# Author:     Sokha, Sin , Sanya, Mesa , Kanel (ALLWEB DEVELOPERS) 
# Status:     Active
# Type:     Process
# Created:     03-April-2009
# Post-History:     20-April-2009
######################################################################

import reports,employees_controller,departments_controller,companies_controller,users_controller,\
experiences_controller,positions_controller, mainpage_controller
from django.conf.urls.defaults import *

urlpatterns = patterns(
    #MainPage   
    'ahrm.main',
    (r'^tinymce/', include('tinymce.urls')),
    (r'^$', 'mainpage_controller.index'),
    (r'index^$', 'mainpage_controller.index'),
    (r'^mainpage$', 'mainpage_controller.goto_mainpage'),
    #About AHRM
    (r'^about_ahrm$', 'mainpage_controller.about_ahrm'),
    
    #...more below here
    
    #Users
         #AUTHENTICATION
    (r'^logout$', 'users_controller.user_logout'),
    (r'^accounts/login', 'users_controller.control_login'),
    (r'^login/verification$', 'users_controller.submit_login'),
    
         #(CRUD)
    (r'^user/create/save$', 'users_controller.user_create'),
    (r'^user/delete/(?P<user_id>\d+)$', 'users_controller.user_delete'),
    (r'^user/edit/save/(?P<user_id>\d+)$', 'users_controller.user_edit'),
    (r'^user/changpwd$', 'users_controller.change_password'),
    (r'^user/pwd/update/(?P<user_id>\d+)$', 'users_controller.user_update_pwd'),
    
         #DISPLAY
    (r'^users/list$', 'users_controller.users_list'),
    (r'^user/new$', 'users_controller.user_create'),
    (r'^user/detail/(?P<user_id>\d+)$', 'users_controller.user_edit'),
    
    
    #...more below here
    
    #Companies
        #CRUD
    (r'^company/edit/(?P<com_id>\d+)$', 'companies_controller.company_edit'),
    (r'^company/enter/(?P<com_id>\d+)$', 'companies_controller.enter_company'),
    (r'^company/delete/(?P<com_id>\d+)$', 'companies_controller.company_delete'),
    (r'^company/new$', 'companies_controller.company_new'),
    (r'^company/change$', 'companies_controller.change_company'),
    
        #DISPLAY
    (r'^movenode/$', 'companies_controller.movenode'),
    (r'^viewdetail/$', 'companies_controller.viewdetail'),
    (r'^companies/list$', 'companies_controller.companies_list'),
    (r'^companies/show$', 'companies_controller.companies_show'),
    (r'^treedata/(?P<id>\d+)/?$', 'companies_controller.treedata'),
    (r'^company/structure/', 'companies_controller.company_structure'),
    (r'^company/initialize$', 'companies_controller.company_inititialize'),
    
    #...more below here
    
    #Employee
        #CRUD
    (r'^employee/edit/(?P<employee_id>\d+)$', 'employees_controller.employee_edit'),
    (r'^employee/delete/(?P<employee_id>\d+)$', 'employees_controller.employee_delete'),
    (r'^employee/new', 'employees_controller.employee_create'),
    (r'^employee/addnewpage', 'employees_controller.goto_newemployee'),
    
        #DISPLAY
    (r'^employees/contacts_list/pdf$', 'reports.contacts_list'),
    (r'^employee/search$', 'employees_controller.search_employee'),
    (r'^employee/personal$', 'employees_controller.goto_newemployee'), 
    (r'^employee/contactlist$', 'employees_controller.employees_contacts_list'),
    
    
    #...more below here
    
    #Employee(EXPERIENCE)
        #CRUD
    (r'^employee/experience/new$', 'experiences_controller.experience_new'),
    (r'^employee/experience_edit/(?P<exp_id>\d+)$', 'experiences_controller.experience_edit'),
    (r'^employee/experience/save$', 'experiences_controller.employee_save_experience'),
    (r'^employee/experience_delete/(?P<exp_id>\d+)$', 'experiences_controller.experience_delete'),
    
       #DISPLAY
    (r'^employee/experience$', 'experiences_controller.employee_create_experience'),
    
    #...more below here
    
    #Employee(EMERGENCY)
       #CRUD
    (r'^employee/emergency/new$', 'employees_controller.employee_new_emergency'),
    (r'^employee/emergency/save$', 'employees_controller.employee_save_emergency'),
    (r'^employee/emergency/edit/(?P<emergency_id>\d+)$', 'employees_controller.employee_edit_emergency'),
    (r'^employee/emergency/delete/(?P<emergency_id>\d+)$', 'employees_controller.employee_delete_emergency'),
       
       #DISPLAY
    (r'^employee/emergency$', 'employees_controller.employee_create_emergency'),
    
    #...more below here
     
    #Employee(EDUCATION)
     
       #CRUD
    (r'^employee/education/new$', 'employees_controller.employee_new_education'),
    (r'^employee/education/save$', 'employees_controller.employee_save_education'),
    (r'^employee/education/delete/(?P<education_id>\d+)$', 'employees_controller.employee_delete_education'),
    (r'^employee/education/edit/(?P<education_id>\d+)$', 'employees_controller.employee_edit_education'),
       #DISPLAY
    (r'^employee/education$', 'employees_controller.employee_create_education'),
     #...more below here
      
    #Employee(REPORT)
       #DISPLAY
    (r'^employee/report/csv/(?P<id>\d+)/?$', 'reports.outputting_csv'),
    (r'^employee/report/pdf/(?P<id>\d+)/?$', 'reports.employee_report'),
    
    #...more below here
    
    #Employee(SKILL)
       #CRUD
    (r'^employee/skill/new$', 'employees_controller.employee_new_skill'),
    (r'^employee/skill/save$', 'employees_controller.employee_save_skill'),
    (r'^employee/skill/edit/(?P<skill_id>\d+)$', 'employees_controller.employee_edit_skill'),
    (r'^employee/skill/delete/(?P<skill_id>\d+)$', 'employees_controller.employee_delete_skill'),
       #DISPLAY
    (r'^employee/skill$', 'employees_controller.employee_create_skill'),
    
    #...more below here
    
    #Employee(LANGUAGES)
       #CRUD
    (r'^employee/languages/new$', 'employees_controller.employee_new_language'),
    (r'^employee/languages/save$', 'employees_controller.employee_save_language'),
    (r'^employee/languages/edit/(?P<emp_lang_id>\d+)$', 'employees_controller.employee_edit_language'),
    (r'^employee/languages/delete/(?P<emp_lang_id>\d+)$', 'employees_controller.employee_delete_language'),
    
       #DISPLAY
    (r'^employee/languages$', 'employees_controller.employee_create_language'),
    
    #...more below here
    
    #Employee(DEPARTMENT)
       #CRUD
    (r'^employee/department/new$', 'employees_controller.employee_department_new'),
    (r'^employee/department/save$', 'employees_controller.employee_department_save'),
    (r'^employee/department/edit/(?P<emp_dep_id>\d+)/?$', 'employees_controller.employee_department_edit'),
    (r'^employee/department/delete/(?P<emp_dep_id>\d+)/?$', 'employees_controller.employee_department_delete'),
    
       #DISPLAY
    (r'^employee/department$', 'employees_controller.employee_department'),
    
     #...more below here
     
     #Employee(ATTACHMENT)
       #CRUD
    (r'^employee/attachment/new$', 'employees_controller.employee_new_attachment'),
    (r'^employee/attachment/save$', 'employees_controller.employee_save_attachment'),
    (r'^employee/attachment/edit/(?P<atch_id>\d+)$', 'employees_controller.employee_edit_attachment'),
    (r'^employee/attachment/delete/(?P<atch_id>\d+)$', 'employees_controller.employee_delete_attachment'),
       
       #DISPLAY
    (r'^employee/attachment$', 'employees_controller.employee_create_attachment'),
    
    #...more below here
    
    #Departments
       #CRUD
    #(r'^$', 'departments_controller.companies_list'),
    (r'^department/save/$', 'departments_controller.department_save'),
    (r'^department/add/$', 'departments_controller.department_process'),
    #(r'^department/delete/$', 'departments_controller.department_delete'),  
    (r'^department/update/$', 'departments_controller.department_update'), 
       
       #DISPLAY
    (r'^department/(?P<dept_id>\d+)$', 'departments_controller.department_display'),
    
    #...more below here
    
    
    #Positions
    
        #CRUD
    (r'^position/save$', 'positions_controller.position_save'),
    (r'^position/new$', 'positions_controller.position_detail'),
    #(r'^position/save/edit/(?P<pos_id>\d+)$', 'views.position_save_edit'),
    (r'^position/edit/(?P<pos_id>\d+)$', 'positions_controller.position_edit'),
    (r'^position/delete/(?P<pos_id>\d+)$', 'positions_controller.position_delete'),
    
       #DISPLAY
    (r'^position$', 'positions_controller.positions_list'),
    
    #...more below here
    
)
