# -*- coding: utf-8 -*-
__author__ = 'Zhao Guoyan'

import socket
from django.shortcuts import render


class userConfig:
    UserName = "_NULL_"
    hadLogin = False
    WORD = "_NULL_"


class tcpManage:
    @staticmethod
    def connectServer(ipAddr='127.0.0.1', port=60000):
        tcpManage.conn = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        tcpManage.conn.connect((ipAddr, port))

    @staticmethod
    def wordQuery(word, username='_NULL_'):
        tcpManage.connectServer()
        tcpManage.conn.send('Query ' + '_NULL_' + ' ' + word + '\n')  # _NULL_:username
        WORD=word
        answer = tcpManage.conn.recv(2048)
        rst = {}
        if not 'NoSuchWord' in answer:
            for web in answer[7:].split('###')[:-1]:
                expPart, rest = web.split(';likenumber:')
                likenum, liked = rest.split(';liked:')
                key = expPart.split(':')[0]
                rst[key.encode('ascii', 'ignore')] = (expPart[len(key):], int(likenum), 'true' in liked)
                # print rst
        tcpManage.conn.close()
        return rst

    @staticmethod
    def login(name, passwd):
        tcpManage.connectServer()
        tcpManage.conn.send('Login ' + name + ' ' + passwd + '\n')
        ans = tcpManage.conn.recv(2048)
        tcpManage.conn.close()
        return 'Success' in ans

    @staticmethod
    def logout(name):
        tcpManage.connectServer()
        tcpManage.conn.send('Logout ' + name + '\n')
        userConfig.UserName = "_NULL_"
        userConfig.hadLogin = False
        ans = tcpManage.conn.recv(2048)
        tcpManage.conn.close()
        return 'Logout' in ans

    @staticmethod
    def register(name, passwd):
        tcpManage.connectServer()
        tcpManage.conn.send('Register ' + name + ' ' + passwd + '\n')
        ans = tcpManage.conn.recv(2048)
        tcpManage.conn.close()
        return 'Success' in ans

    @staticmethod
    def clickLike(word, src, name):
        tcpManage.connectServer()
        tcpManage.conn.send('Like ' + name + ' ' + word + ' ' + src + '\n')
        ans = tcpManage.conn.recv(2048)
        tcpManage.conn.close()
        return 'Success' in ans

    @staticmethod
    def share(me, dest, word, src, exp):
        pass
        # conn.send('Share ' + dest + '###' + word + '###' + src + '###' + exp + '###' + me + '\n')
        # return conn.recv(2048)

    @staticmethod
    def likeList(name):
        tcpManage.connectServer()
        tcpManage.conn.send('Word ' + name + '\n')
        rst = ()
        likelist = tcpManage.conn.recv(2048).split(' ')[1:]
        for item in likelist:
            rst.append(item.split(':'))
        tcpManage.conn.close()
        return rst

    @staticmethod
    def onlineList():
        tcpManage.conn.send('User\n')
        online, offline = tcpManage.conn.recv(2048).split('###')
        rst = ()
        rst.append(online.split(' '))
        rst.append(offline.split(' '))
        return rst

    @staticmethod
    def goodbye():
        tcpManage.conn.send('Bye!\n')
        tcpManage.conn.close()


def user_login(request):
    request.encoding = 'utf-8'
    username = request.POST['username'].encode('utf-8')
    password = request.POST['password'].encode('utf-8')
    print username
    print password
    if tcpManage.login(username, password):
        login_error = False
        userConfig.UserName = username
        userConfig.hadLogin = True
        tempLogin = userConfig.hadLogin
        tempUsername = userConfig.UserName
        return render(request, 'home.html', locals())
    else:
        login_error = True
        print 'login failed'
        tempLogin = False
        return render(request, 'login.html', locals())


def logout(request):
    tcpManage.logout(userConfig.UserName)
    userConfig.UserName = "_NULL_"
    return render(request, 'home.html', locals())


def user_register(request):
    request.encoding = 'utf-8'
    username = request.POST['username'].encode('utf-8')
    password = request.POST['password'].encode('utf-8')
    print username
    print password
    if tcpManage.register(username, password):
        register_error = False
        print 'register success'
        register_success = True
        return render(request, 'register.html', locals())
    else:
        register_error = True
        print 'register failed'
        return render(request, 'register.html', locals())


def user_clickLike_baidu(request):
    request.encoding = 'utf-8'
    if tcpManage.clickLike(userConfig.WORD, 'baidu', userConfig.UserName):
        return render(request, 'search_result.html', locals())
    else:
        return render(request,'click_fail.html',locals())
