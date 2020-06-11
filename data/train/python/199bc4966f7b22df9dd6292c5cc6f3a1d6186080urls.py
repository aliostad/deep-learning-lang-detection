from django.conf.urls import *

from . import views

urlpatterns = [

    url(r'^search$', views.search, name="repository-search"),
    url(r'^newScore$', views.newScore, name="repository-newScore"),
    url(r'^showRepositoryProduction/(?P<pk>\d+)$', views.showRepositoryProduction, name="repository-showRepositoryProduction"),
    url(r'^showRepositoryDeveloppement/(?P<pk>\d+)$', views.showRepositoryDeveloppement, name="repository-showRepositoryDeveloppement"),
    url(r'^addFile/(?P<pk>\d+)$', views.addFile, name="repository-addFile"),
    url(r'^editRepository/(?P<pk>\d+)$', views.editRepository, name="repository-editRepository"),
    url(r'^deleteRepository/(?P<pk>\d+)$', views.deleteRepository, name="repository-deleteRepository"),
    url(r'^deleteFile/(?P<pk>\d+)/(?P<pk_commit>\d+)$', views.deleteFile, name="repository-deleteFile"),
    url(r'^deleteCommit/(?P<pk>\d+)$', views.deleteCommit, name="repository-deleteCommit"),
    url(r'^renameFile/(?P<pk>\d+)/(?P<pk_commit>\d+)$', views.renameFile, name="repository-renameFile"),
    url(r'^replaceFile/(?P<pk>\d+)/$', views.replaceFile, name="repository-replaceFile"),
    url(r'^mergeCommit/(?P<pk>\d+)$', views.mergeCommit, name="repository-mergeCommit"),
    url(r'^showFile/(?P<pk>\d+)/(?P<pk_commit>\d+)$', views.showFile, name="repository-showFile"),
    url(r'^downloadViewsFile/(?P<pk>.+)/(?P<pk_commit>.+)$', views.downloadViewsFile, name="repository-downloadViewsFile"),
    url(r'^downloadCommit/(?P<pk>.+)/$', views.downloadCommit, name="repository-downloadCommit"),
    url(r'^createBranch/(?P<pk>.+)/$', views.createBranch, name="repository-createBranch"),
    url(r'^updateDatabase/(?P<pk>.+)/$', views.updateDatabase, name="repository-updateDatabase"),
    url(r'^deleteBranch/(?P<pk>.+)/$', views.deleteBranch, name="repository-deleteBranch"),
    url(r'^editMarkdown/(?P<pk>.+)/(?P<pk_file>.+)$', views.editMarkdown, name="repository-editMarkdown"),

    url(r'^warningDownloadFile/(?P<pk>\d+)/(?P<pk_commit>\d+)$', views.warningDownloadFile, name="repository-warningDownloadFile"),
    url(r'^downloadFile/(?P<pk>.+)/$', views.downloadFile, name="repository-downloadFile"),

    url(r'^warningDownloadRepository/(?P<pk>\d+)$', views.warningDownloadRepository, name="repository-warningDownloadRepository"),
    #url(r'^downloadRepository$', 'downloadRepository', name="repository-downloadRepository"),

    url(r'^warningDownloadCommit/(?P<pk>\d+)/(?P<pk_commit>\d+)$', views.warningDownloadCommit, name="repository-warningDownloadCommit"),
    url(r'^downloadCommit$', views.downloadCommit, name="repository-downloadCommit"),

    url(r'^changeDeprecated/(?P<pk>\d+)/(?P<boolean>\d+)$', views.changeDeprecated, name="repository-changeDeprecated"),
    url(r'^changeCommitVisibility/(?P<pk>\d+)/(?P<boolean>\d+)$', views.changeCommitVisibility, name="repository-changeCommitVisibility"),
    url(r'^restartRepositoryByOldCommit/(?P<pk>\d+)/$', views.restartRepositoryByOldCommit, name="repository-restartRepositoryByOldCommit"),

    url(r'^commits/(?P<pk>\d+)$', views.listCommits, name="repository-listCommits"),
    url(r'^listContributeurs/(?P<pk>\d+)$', views.listContributeurs, name="repository-listContributeurs"),
    
    url(r'^listDownload$', views.listDownload, name="repository-listDownload"),
    url(r'^tagCommit/(?P<pk>\d+)$', views.tagCommit, name="repository-tagCommit"),
    url(r'^convertFile/(?P<pk>\d+)$', views.convertFile, name="repository-convertFile"),


]
