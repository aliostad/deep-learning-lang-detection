# -*- coding: UTF-8 -*-
# Create your views here.
from django.shortcuts import render_to_response
from django.http import HttpResponse,HttpResponseRedirect
from django.template import RequestContext
from django.views.decorators.csrf import csrf_exempt
import adapters,config,string,json
from chongwug.commom import __errorcode__
from chongwug.config import __adtypes,__knowledgetypes
MANAGE_ROOT='/manage/'

def manage_login(request):
    return render_to_response('manager/tpl/manage_login.html',{},context_instance=RequestContext(request))

#auth:huhuaiyong
#date:2014/8/23
#discription:管理员首页展示
def manage_home_view(request):
    if request.method == 'POST' and 'username' in request.POST and 'userpassd'  in request.POST:
        if adapters.manage_login_check(request) == True:
            return HttpResponseRedirect(MANAGE_ROOT)
    if request.method == 'GET' and 'logout' in request.GET:
        del request.session['manage_id']
        del request.session['score']
        return HttpResponseRedirect(MANAGE_ROOT)
    if adapters.manage_authentication(request) == False:
        return manage_login(request)
    data = adapters.manage_home_data_get(request)
    return render_to_response('manager/tpl/manage_home.html',data)

def address_handle_view(request):
    data = adapters.addressHandle(request)
    return HttpResponse(json.dumps(data))
    
def manage_pet_farm_add_view(request):
    if adapters.manage_authentication(request) == False:
        return HttpResponseRedirect(MANAGE_ROOT)
    if request.session['score'] < 50:
        return render_to_response('404.html')
    if request.method == 'POST':
        return HttpResponse(adapters.manage_pet_farm_add(request))
    data = adapters.manage_home_data_get(request)
    pagedata = adapters.addressHandle(request)
    pagedata['manager'] = data['manager']
    pagedata['directs'] = data['directs']
    form = adapters.descform()
    medialist = str(form.media).split('\n')
    media = '%s\n%s' % (medialist[-2],medialist[-1])
    pagedata['form'] = form
    pagedata['media'] = media
    return render_to_response('manager/tpl/manage_pet_farm_add.html',pagedata,context_instance=RequestContext(request))

def manage_ad_add_view(request):
    if adapters.manage_authentication(request) == False:
        return HttpResponseRedirect(MANAGE_ROOT)
    if request.session['score'] < 50:
        return render_to_response('404.html')
    data = adapters.manage_home_data_get(request)
    ad_types = adapters.manage_get_adtypes()
    data['ad_types'] = ad_types
    data['width'] = __adtypes[0][3]
    data['height'] = __adtypes[0][4]
    data['sessionid'] = request.COOKIES['sessionid']
    return render_to_response('manager/tpl/manage_ad_picadd.html',data,context_instance=RequestContext(request))

@csrf_exempt
def manage_ad_pic_upload_view(request):
    if adapters.manage_authentication(request) == False:
        return HttpResponse(__errorcode__(404))
    if request.session['score'] < 50:
        return render_to_response('404.html')
    photo = request.FILES.get('Filedata',None)
    return HttpResponse(adapters.manage_picupload(photo,__adtypes[0][3],__adtypes[0][4]))

def manage_ad_picpre_view(request):
    if adapters.manage_authentication(request) == False:
        return HttpResponseRedirect(MANAGE_ROOT)
    if request.session['score'] < 50:
        return render_to_response('404.html')
    return HttpResponse(adapters.manage_ad_picpreupload(request,__adtypes[0][3],__adtypes[0][4]))

def manage_ad_del_view(request):
    if adapters.manage_authentication(request) == False:
        return HttpResponseRedirect(MANAGE_ROOT)
    if request.session['score'] < 50:
        return render_to_response('404.html')
    data = adapters.manage_home_data_get(request)
    data['adinfo'] = adapters.manage_ad_del(request) 
    if data['adinfo'] == 'False':
        return HttpResponse(__errorcode__(1))
    else:
        return render_to_response('manager/tpl/manage_ad_del.html',data,context_instance=RequestContext(request))

def manage_ad_select_view(request):
    if adapters.manage_authentication(request) == False:
        return HttpResponseRedirect(MANAGE_ROOT)
    if request.session['score'] < 50:
        return render_to_response('404.html')
    return HttpResponse(adapters.manage_ad_select(request))

def manage_supplie_add_view(request):
    if adapters.manage_authentication(request) == False:
        return HttpResponseRedirect(MANAGE_ROOT)
    if request.session['score'] < 50:
        return render_to_response('404.html')
    if request.method == 'POST':
        photo = request.FILES.get('imgurl',None)
        data = adapters.manage_supplie_add(request,photo)
        if not data:
            return HttpResponse(u'数据错误，请检查上传的数据，再重新上传')
    data = adapters.manage_home_data_get(request)
    data['types'] = config.__supplietypes
    return render_to_response('manager/tpl/manage_supplie_add.html',data,context_instance=RequestContext(request))

def manage_supplie_mod_view(request):
    if adapters.manage_authentication(request) == False:
        return HttpResponseRedirect(MANAGE_ROOT)
    if request.session['score'] < 50:
        return render_to_response('404.html')
    if request.method == 'POST':
        photo = request.FILES.get('imgurl',None)
        data = adapters.manage_supplie_mod(request,photo)
        if not data:
            data = adapters.manage_home_data_get(request)
            data['types'] = config.__supplietypes
            data['supplie'] = adapters.manage_get_supplie(string.atoi(request.POST['id']))
            data['error'] = u'修改失败，请检查是否存在输入数据异常'
            return render_to_response('manager/tpl/manage_supplie_mod_item.html',data,context_instance=RequestContext(request))
        return HttpResponseRedirect(MANAGE_ROOT +'supplie/mod/')
    
    data = adapters.manage_home_data_get(request)
    data['types'] = config.__supplietypes
    if 'id' in request.GET:
        data['supplie'] = adapters.manage_get_supplie(string.atoi(request.REQUEST.get('id')))
        return render_to_response('manager/tpl/manage_supplie_mod_item.html',data,context_instance=RequestContext(request))
    elif 'del' in request.GET:
        adapters.manage_del_supplie(request)
        return HttpResponseRedirect(MANAGE_ROOT +'supplie/mod/')
    else:
        data['supplietype'],data['supplies'] = adapters.manage_get_supplies(request)
        return render_to_response('manager/tpl/manage_supplie_mod.html',data,context_instance=RequestContext(request))

def manage_knowledge_mode_view(request):
    if adapters.manage_authentication(request) == False:
        return HttpResponseRedirect(MANAGE_ROOT)
    if request.session['score'] < 50:
        return render_to_response('404.html')
    data = adapters.manage_home_data_get(request)
    if request.method == 'POST':
        if not adapters.manage_knowledge_mod(request):
            data['types'] = __knowledgetypes
            data['knowledges'] = adapters.manage_get_knowledges(request,id=string.atoi(request.POST['id']))
            data['error'] = u'修改失败，请检查是否存在输入数据异常'
            return render_to_response('manager/tpl/manage_bringupknowledge_mod_item.html',data,context_instance=RequestContext(request))
        return HttpResponseRedirect(MANAGE_ROOT +'knowledge/mod/')
    
    data['types'] = __knowledgetypes
    if 'type' in request.GET:
        data['curtype'] = string.atoi(request.REQUEST.get('type'))
    if 'id' in request.GET:
        data['knowledge'] = adapters.manage_get_knowledges(request,string.atoi(request.REQUEST.get('id')))
        return render_to_response('manager/tpl/manage_bringupknowledge_mod_item.html',data,context_instance=RequestContext(request))
    else:
        data['knowledges'] = adapters.manage_get_knowledges(request)
        return render_to_response('manager/tpl/manage_bringupknowledge_mod.html',data)

def manage_config_view(request,who):
    if adapters.manage_authentication(request) == False:
        return HttpResponseRedirect(MANAGE_ROOT)
    if request.session['score'] < 50:
        return render_to_response('404.html')
    data,redirect = adapters.manage_config(request,who)
    if redirect == True:
        return HttpResponseRedirect(MANAGE_ROOT +('config/%s/' % who))
    elif redirect == False:
        return render_to_response('manager/tpl/manage_config_%s.html' % who,data)
    else:
        return HttpResponse(data)

def manage_verify_view(request):
    if adapters.manage_authentication(request) == False:
        return HttpResponseRedirect(MANAGE_ROOT)
    if request.session['score'] < 50:
        return render_to_response('404.html')
    if 'verify' in request.GET:
        adapters.manage_verify_newusers(request)
    data = adapters.manage_home_data_get(request)
    data['users'] = adapters.manage_get_newusers()
    return render_to_response('manager/tpl/manage_verify.html',data)

def manage_verifyinfo_view(request):
    if adapters.manage_authentication(request) == False:
        return HttpResponseRedirect(MANAGE_ROOT)
    if request.session['score'] < 50:
        return render_to_response('404.html')
    if 'verify' in request.GET:
        adapters.manage_verify_newpets(request)
    data = adapters.manage_home_data_get(request)
    data['pets'] = adapters.manage_get_newpets()
    return render_to_response('manager/tpl/manage_verifyinfo.html',data)