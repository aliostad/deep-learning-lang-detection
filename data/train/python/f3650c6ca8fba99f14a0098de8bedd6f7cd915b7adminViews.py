
from manage import ContentManage
manage = ContentManage()

from manage import parameter_checking as __validation__
def IP(r): return r.META["REMOTE_ADDR"]

def tag_list(r, cate='lei', lang='zh'):    
    cate = manage.load_category(cate, lang)
    tag_count, tags_list = manage.tag_list(cate, 1, 100,)
    cate_count, cate_list = manage.cate_list(lang)
    
    return ("dyd_admin_tag.html", {
                                   'cur_cate': cate,
                                   "tags_list": tags_list,
                                   "cate_list": cate_list,                                    
                                   })
    
    
def update_tag(r, cate='', lang='', tag='', shape=''):
    cate = manage.load_category(cate, lang)
    tag = manage.load_tag(cate, tag)
    tag.shape = shape
    tag.put()
    manage.clear_cache()
    
    return ("redirect:/dyd/admin/tag_list", ) #tag_list(r, cate.code, lang)


def admin_post(r, cate='lei', lang='zh', message='', tags='', user='', session='', track='', ajax='N'):
    
    cate = manage.load_category(cate, lang)
    tag_count, tags_list = manage.tag_list(cate, 1, 100,)
    cate_count, cate_list = manage.cate_list(lang)
    
    if r.POST:
        (status, err_msg) = manage.post(cate, message, tags, user, track, IP(r))
        result = {"status": status, "message": err_msg}
    else:
        result = []
    
    return ("dyd_admin_message.html", {
                                    "tags": tags,
                                    "result": result,
                                   "cur_cate": cate,
                                   "tags_list": tags_list,
                                   "cate_list": cate_list,                                    
                                   })

