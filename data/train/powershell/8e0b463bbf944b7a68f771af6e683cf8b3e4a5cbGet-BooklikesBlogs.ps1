#
# Pull down reviews from booklikes
# See http://booklikes.com/dev/myapps
#     http://booklikes.com/dev/docs
#
# Applications:
#   Name: William Powell Syncer
#   key: eaac7168da64a0495be668173fa1481e
#
# booklikes.com/williamcampbellpowell/login?key=eaac7168da64a0495be668173fa1481e
#
# http://booklikes.com/api/v1_05/book/GetUserBooks?key=eaac7168da64a0495be668173fa1481e&uid=WilliamCampbellPowell
#
# These are the two that work:
#
# http://booklikes.com/api/v1_05/user/login?key=eaac7168da64a0495be668173fa1481e&email=booklikes@poco.co.uk&password=Palimp5est
#
# This returns a usr_token which is needed in the next piece:
#
# http://booklikes.com/api/v1_05/post/GetUserPosts?key=eaac7168da64a0495be668173fa1481e&uid=WilliamCampbellPowell&usr_token=a1f722e45c26567674669f112ffa573a&Page=0&PerPage=5
#

