# -*- coding: utf-8 -*-
try:
    from os import getuid
except ImportError:
    def getuid():
        return 4000

from dispatch import Dispatch
from post import Post
from sendDispatch import *

from flask import Flask, render_template, request, redirect
import json, datetime, time, random, os, shutil, sys
from werkzeug import secure_filename
app = Flask(__name__, template_folder='templates')


def renderDispatches():
    disp_dict = {}
    try:
        disp_list = os.listdir(os.getcwd() + '/dispatches')
    except Exception as e:
        print(e)
        print('creating dispatches directory...')
        os.mkdir(os.getcwd() + '/dispatches')
        disp_list = os.listdir(os.getcwd() + '/dispatches')
    if disp_list == []:
        d = Dispatch(0)
        disp_list = os.listdir('dispatches')
    disp_list = [i for i in disp_list if i not in  ['0', 0]]
    for i in disp_list:
        disp_dict[i] = []
        d = Dispatch(i)
        d_id = d.id_
        d_interval = d.interval
        post_list = os.listdir('dispatches/%s/posts'%d_id)
        post_list = [i for i in post_list if i not in  ['0', 0]]
        for p in post_list:
            p = Post(p, d_id)
            p = p.post_data
            disp_dict[i].append(p)
        disp_dict[i] = [d_interval] + disp_dict[i]
    print(disp_dict)
    return disp_dict


def sleepTime(sltime):
    int_ = int(round(sltime, 0))
    rmng = sltime - int_
    while int_ != 0:
        time.sleep(1)
        sys.stdout.write('\rsleeping: %s seconds remaining'%int_)
        sys.stdout.flush()
        int_ -= 1
    sys.stdout.write('\rsleeping: %s seconds remaining'%rmng)
    sys.stdout.flush()
    time.sleep(rmng)
    print('\rslept for %s seconds. waking up now.'%sltime)


@app.route("/", methods=['GET', 'POST'])
def index():
    d = renderDispatches()
    try:
        access_tokens = loadListFromFile('access_tokens.txt')
        lat = len(access_tokens)
    except:
        lat = 0
    return render_template('index.html', dispatches = d, lat = lat)


@app.route("/upload_group_ids_list/<dispatch_id>", methods=['GET', 'POST'])
def uploadGroupIdsList(dispatch_id):
    if request.method == 'POST':
        f = request.files['file']
        f.save('group_ids_list.txt')
    return redirect('/dispatch/%s'%dispatch_id)


@app.route("/remove_group_ids_list/<dispatch_id>", methods=['GET', 'POST'])
def removeGroupIdsList(dispatch_id):
    if request.method == 'POST':
        f = open('group_ids_list.txt', 'w', encoding='utf8')
        f.close()
    return redirect('/dispatch/%s'%dispatch_id)


@app.route("/remove_access_tokens", methods=['GET', 'POST'])
def removeAccessTokensList():
    if request.method == 'POST':
        f = open('access_tokens.txt', 'w', encoding='utf8')
        f.close()
    return redirect('/')


@app.route("/upload_access_tokens_list", methods=['GET', 'POST'])
def uploadAccessTokensList():
    if request.method == 'POST':
        f = request.files['file']
        f.save('access_tokens.txt')
    return redirect('/')


@app.route("/upload_photo/<dispatch_id>/<post_id>", methods=['GET', 'POST'])
def uploadPhoto(dispatch_id, post_id):
    if request.method == 'POST':
        f = request.files['file']
        f.save('dispatches/%s/posts/%s/photos/'%(dispatch_id, post_id) +  secure_filename(f.filename))

    return redirect('/dispatch/%s'%dispatch_id)


@app.route("/remove_dispatch", methods=['GET', 'POST'])
def removeDispatch():
    if request.method == "POST":
        dispatch_id = request.form['remove_dispatch']
        d = Dispatch(dispatch_id)
        d.removeDispatch()
    return redirect('/')


@app.route("/add_dispatch", methods=['GET', 'POST'])
def addDispatch():
    if request.method == "POST":
        d = Dispatch(0)
        i = d.id_
        p = Post(0, i)
    return redirect('/')


@app.route("/dispatch/<dispatch_id>", methods=['GET', 'POST'])
def displayDispatch(dispatch_id):
    d = renderDispatches()
    d = d[dispatch_id]
    interval, d = d[0], d[1:]
    group_ids_list = loadListFromFile('group_ids_list.txt')
    gidlist = ['https://vk.com/public'+i.replace('-', '') for i in group_ids_list]
    return render_template('dispatch.html', dispatch_id = dispatch_id, d = d,posts_am=len(d), interval = interval, group_ids_list = group_ids_list, gidlist = gidlist)


@app.route("/save_post/<dispatch_id>/<post_id>", methods=['GET', 'POST'])
def savePost(dispatch_id, post_id):
    if request.method == "POST":
        p = Post(post_id, dispatch_id)
        print(p.post_data)
        tx = request.form['text']
        ln = request.form['link']
        # print('link from page: %s'%ln)
        if tx != '':
            p.addText(tx)
        if ln != '':
            p.addLink(ln)
        print(p.post_data)
    return redirect('/dispatch/%s'%dispatch_id)


@app.route("/add_post/<dispatch_id>", methods=['GET', 'POST'])
def addPost(dispatch_id):
    if request.method == "POST":
        p = Post(0, dispatch_id)
    return redirect('/dispatch/%s'%dispatch_id)


@app.route("/copy_post/<dispatch_id>/<post_id>", methods=['GET', 'POST'])
def copyPost(dispatch_id, post_id):
    if request.method == "POST":
        old_post = Post(post_id, dispatch_id)
        d = old_post.post_data
        print(d)
        new_post = Post(0, dispatch_id)
        new_post.addText(d['text'])
        new_post.addLink(d['link'])
        for photo in d['photos']:
            shutil.copy(photo, new_post.folder + '/photos')
    return redirect('/dispatch/%s'%dispatch_id)



@app.route("/remove_post/<dispatch_id>/<post_id>", methods=['GET', 'POST'])
def removePost(dispatch_id, post_id):
    if request.method == "POST":
        p = Post(post_id, dispatch_id)
        p.removePost()
    return redirect('/dispatch/%s'%dispatch_id)


@app.route("/send_test_post/<dispatch_id>/<post_id>", methods=['GET', 'POST'])
def sendTestPost(dispatch_id, post_id):
    if request.method == "POST":
        p = Post(post_id, dispatch_id)
        p = p.post_data
        print(p)
        access_tokens = loadListFromFile('access_tokens.txt')
        g = '-150121997'
        sendPost(random.choice(access_tokens), p, g, interval = 0.333333)

    return redirect('/dispatch/%s'%dispatch_id)


@app.route("/set_interval/<dispatch_id>", methods=['GET', 'POST'])
def setInterval(dispatch_id):
    interval = request.form['interval']
    interval = interval.replace(',', '.')
    try:
        interval = float(interval)
        print('interval from form: %s'%interval)
        print(type(interval), interval)
        if interval < 0.3333333:
            interval = 0.3333333
        f = open('dispatches/%s/delay.txt'%dispatch_id, 'w', encoding='utf8')
        # f.write(interval)
        print(interval, file=f)
        f.close()
    except:
        pass
    return redirect('/dispatch/%s'%dispatch_id)


@app.route("/send_dispatch/<dispatch_id>", methods=['GET', 'POST'])
def sendDispatch(dispatch_id):

    if request.method == "POST":
        available_posts = []
        for i in os.listdir('dispatches/%s/posts'%dispatch_id):
            p = Post(i, dispatch_id)
            p = p.post_data
            if p['id'] != '0':
                available_posts.append(p)
        print('available_posts', available_posts)


        interval = open('%s/dispatches/%s/delay.txt'%(os.getcwd(), dispatch_id)).read().split('\n')[0]
        interval = float(interval)
        # print(interval)


        group_ids_list = loadListFromFile('group_ids_list.txt')
        access_tokens = loadListFromFile('access_tokens.txt')

        for a in range(len(access_tokens)):
            access_token = access_tokens[a]
            print('access_token: %s'%access_token)
            try:
                for g in group_ids_list:
                    post_to_send = random.choice(available_posts)
                    print('post %s will be sent to group d%s'%(post_to_send, g))
                    sendPost(access_token, post_to_send, g, interval)
                    sleepTime(interval)
            except Exception as e:
                print('cant send due to ', e)
                if a == len(access_tokens):
                    print('no more access_tokens')
                    break
                else:
                    continue

    return redirect('/dispatch/%s'%dispatch_id)



if __name__ == "__main__":
    app.run(port=getuid() + 1000)
