#coding=utf-8
__author__ = 'Administrator'

from blog.default import views
def fun_template():
    '''
    default 模板的 方法控制器
    '''
    funMap={}
    funMap['404']=(views.page404,('/404.html',))
    funMap['index']=(views.index,('/index.html',))
    funMap['blogAdmin']=(views.blogAdmin,('/admindefault.html',))
    funMap['manageMenu']=(views.manageMenu,('/adminMenu.html',))
    funMap['manageMenu_save']=(views.manageMenu_save,('/adminMenu.html',))
    funMap['webinfo']=(views.webinfo,('/admindefault.html',))
    funMap['AdminInfo']=(views.adminInfo,('/adminInfo.html',))
    funMap['AdminInfo_save']=(views.adminInfo_save,('/adminInfo.html',))
    funMap['managePaper_save']=(views.managePaper_save,('/adminedit.html',))
    funMap['managePaperImage_save']=(views.managePaperImage_save,('/adminimageedit.html',))
    funMap['managePaperImage_upload']=(views.managePaperImage_upload,('/adminimageedit.html',))
    funMap['managePaper_list']=(views.managePaper_list,('/adminPaperList.html',))
    funMap['manageAlbum_list']=(views.manageAlbum_list,('/adminAlbumList.html',))
    funMap['manageAlbum_save']=(views.manageAlbum_save,('/adminAlbumSave.html',))
    funMap['manageAlbum_upload']=(views.manageAlbum_upload,('/adminalbumupload.html',))
    funMap['paper']=(views.paperShow,('/paper.html','/paperImage.html'))

    funMap['paperlist']=(views.paperlist,('/paperlist.html',))
    funMap['albumlist']=(views.albumlist,('/albumlist.html',))
    funMap['albumshow']=(views.albumShow,('/albumImage.html',))#尚未写好
    funMap['column']=(views.column,('/column.html',))
    funMap['keywords']=(views.keywords,('/column.html',))
    funMap['commentAdd']=(views.commentAdd,('',))
    funMap['commentList']=(views.commentList,('',))
    funMap['papercount']=(views.papercount,('',))
    funMap['websiteNum']=(views.websiteNum,('',))
    funMap['emailSubscribe']=(views.emailSubscribe,('/emailSubscribe.html',))
    # funMap['picshow']=(views.picshow,('',))
    funMap['getImageListByTitleId']=(views.getImageListByTitleId,('',))
    funMap['saveImageInfoByTitleId']=(views.saveImageInfoByTitleId,('',))
    funMap['delImageInfoByImgId']=(views.delImageInfoByImgId,('',))


    return funMap