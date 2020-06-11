
from manage import ContentManage

manage = ContentManage()

def IP(r): return r.META["REMOTE_ADDR"]

def tag_list(r, cate='', lang='', offset=0, limit=100, mode='list', track=''):
    cate = manage.load_category(cate, lang)
    count, tags = manage.tag_list(cate, offset, limit, mode, track, IP(r))
    r = []
    for t in tags:
        r.append({})
        r[-1]['name'] = t.name
        r[-1]['shape'] = t.shape
        r[-1]['count'] = t.count
    return (count, r)

def cate_list(r, lang='', track=''):
    count, cates = manage.cate_list(lang, track, IP(r))
    r = []
    for t in cates:
        r.append({})
        r[-1]['id'] = t.id
        r[-1]['code'] = t.code
        r[-1]['name'] = t.name 
    return (count, r)

def tag(r, cate='', lang='', tag='', offset=0, limit=50, mode='list', track=''):
    cate = manage.load_category(cate, lang)
    count, messages = manage.tag(cate, tag, offset, limit, mode, track, IP(r))
    
    if mode == 'randmom': messages = manage.random(messages, 1)
    r = []
    for t in messages:
        r.append({})
        r[-1]['id'] = t.id
        r[-1]['create_date'] = t.create_date
        r[-1]['text'] = t.text
        r[-1]['tags'] = t.tags
        
    return (count, r)    
    

def cate(r, cate='', lang='', offset=0, limit=50, mode='list', track=''):
    """
    mode: list, random, hot, new
    """
    cate = manage.load_category(cate, lang)
    count, messages = manage.cate(cate, tag, offset, limit, mode, track, IP(r))
    
    if mode == 'randmom': messages = manage.random(messages, 1)
    r = []
    for t in messages:
        r.append({})
        r[-1]['id'] = t.id
        r[-1]['create_date'] = t.create_date
        r[-1]['text'] = t.text
        r[-1]['tags'] = t.tags
        
    return (count, r)

def vote(r, cate='', lang='', msg_id='', v='', msg='', user='', session='', track=''):
    cate = manage.load_category(cate, lang)
    user = manage.load_user(user, session)
    error, message = manage.vote(cate, msg_id, v, msg, user, track, IP(r))

    error = error is None and "OK" or error
    return {"status": error, "message": message}
        
def post(r, cate='', lang='', message='', tags='', user='', session='', track=''):
    cate = manage.load_category(cate, lang)
    user = manage.load_user(user, session)
    error, message = manage.post(cate, message, user, track, IP(r))
    
    error = error is None and "OK" or error    
    return {"status": error, "message": message}




