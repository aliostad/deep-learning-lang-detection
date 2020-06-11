import json
import datetime
import socket

import treehole.api.article as article
import treehole.api.primary_comment as primary_comment
import treehole.api.reg_login as reg_login
import treehole.api.secondary_comment as secondary_comment
import treehole.api.user as user
import treehole.api.upload as upload

from flask import Flask, make_response
from flask_restful import Api

from treehole.utils.load_config import config


# 设置socket超时防止假死
socket.setdefaulttimeout(10)

app = Flask(__name__)
api = Api(app)


def myconverter(o):
    if isinstance(o, datetime.datetime):
        return o.__str__()


# 跨域请求
@api.representation('application/json')
def output_json(data, code, headers=None):
    resp = make_response(json.dumps(data, default=myconverter), code)
    resp.headers.extend(headers or {'Access-Control-Allow-Origin': '*'})
    return resp


api.add_resource(reg_login.Register, "/api/register")
api.add_resource(reg_login.CheckUsername, "/api/checkusername")
api.add_resource(reg_login.Login, "/api/login")
api.add_resource(user.GetUser, "/api/user/getuser")
api.add_resource(user.Alter, "/api/user/alter")
api.add_resource(user.CheckIn, "/api/user/checkin")
api.add_resource(user.Tip, "/api/user/tip")
api.add_resource(user.IsTipped, "/api/user/istipped")
api.add_resource(user.MoneyIncHistory, "/api/user/mih")
api.add_resource(user.MoneyDecHistory, "/api/user/mdh")
api.add_resource(user.MoneyHistory, "/api/user/mh")
api.add_resource(article.Announce, "/api/article/announce")
api.add_resource(article.DeleteArticle, "/api/article/del")
api.add_resource(article.AlterArticle, "/api/article/alter")
api.add_resource(article.GetOneArticle, "/api/article/getone")
api.add_resource(article.GetLatest, "/api/article/getlatest")
api.add_resource(article.GetArticles, "/api/article/getarticles")
api.add_resource(article.Click, "/api/article/click")
api.add_resource(article.GetLatestUid, "/api/article/getlatest_uid")
api.add_resource(article.GetArticlesUid, "/api/article/getarticles_uid")
api.add_resource(primary_comment.PostComment, "/api/pc/post")
api.add_resource(primary_comment.DelComment, "/api/pc/del")
api.add_resource(primary_comment.AlterComment, "/api/pc/alter")
api.add_resource(primary_comment.GetOneComment, "/api/pc/getone")
api.add_resource(primary_comment.GetLatestComment, "/api/pc/getlatest")
api.add_resource(primary_comment.GetComments, "/api/pc/getcomments")
api.add_resource(primary_comment.GetLatestCommentUid, "/api/pc/getlatest_uid")
api.add_resource(primary_comment.GetCommentsUid, "/api/pc/getcomments_uid")
api.add_resource(primary_comment.Like, "/api/pc/like")
api.add_resource(primary_comment.IsLiked, "/api/pc/isliked")
api.add_resource(secondary_comment.PostCommentS, "/api/sc/post")
api.add_resource(secondary_comment.DelCommentS, "/api/sc/del")
api.add_resource(secondary_comment.AlterCommentS, "/api/sc/alter")
api.add_resource(secondary_comment.GetOneS, "/api/sc/getone")
api.add_resource(secondary_comment.GetLatestS, "/api/sc/getlatest")
api.add_resource(secondary_comment.GetCommentsS, "/api/sc/getcomments")
api.add_resource(secondary_comment.GetLatestSUID, "/api/sc/getlatest_uid")
api.add_resource(secondary_comment.GetCommentsSUID, "/api/sc/getcomments_uid")
api.add_resource(secondary_comment.LikeS, "/api/sc/like")
api.add_resource(secondary_comment.IsLikedS, "/api/sc/isliked")
api.add_resource(upload.UploadImg, "/api/other/uploadimg")