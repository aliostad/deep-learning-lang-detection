<?php
# ---------------------------------------------------------------------
# rth is a requirement, test, and bugtracking system
# Copyright (C) 2005 George Holbrook - rth@lists.sourceforge.net
# This program is distributed under the terms and conditions of the GPL
# See the README and LICENSE files for details
#----------------------------------------------------------------------
# ------------------------------------
# Include API
#
# $RCSfile: include_api.php,v $ $Revision: 1.5 $
# ------------------------------------

include'./api/timer_api.php';
$g_timer = new BC_Timer;
include'./api/properties_inc.php';
include'./api/error_api.php';
include'./api/lang_api.php';
include'./api/session_api.php';
include'./api/db_api.php';
include'./api/authentication_api.php';
include'./api/util_api.php';
include'./api/date_api.php';
include'./api/html_api.php';
include'./api/log_api.php';
include'./api/filter_api.php';
include'./api/project_api.php';
include'./api/user_api.php';
include'./api/test_api.php';
include'./api/bug_api.php';
include'./api/testset_api.php';
include'./api/results_api.php';
include'./api/ldap_api.php';
include'./api/admin_api.php';
include'./api/requirement_api.php';
include'./api/file_api.php';
include'./api/email_api.php';
include'./api/report_api.php';
include'./api/discussion_api.php';
include'./api/news_api.php';
include'./api/graph_api.php';
include'./fckeditor/fckeditor.php';
include'./api/build_api.php';
include'./api/release_api.php';

# ------------------------------
# $Log: include_api.php,v $
# Revision 1.5  2008/07/17 13:54:12  peter_thal
# added new feature: test sets status (overview)
# +fixed some bugs with project_id parameter in testdetail_page references
#
# Revision 1.4  2006/12/05 05:29:19  gth2
# updates for 1.6.1 release
#
# Revision 1.3  2006/09/27 06:09:07  gth2
# correcting case sensativity with FCKeditor - gth
#
# Revision 1.2  2006/08/01 23:41:42  gth2
# fixing bug related to fckeditor - gth
#
# Revision 1.1.1.1  2005/11/30 23:01:12  gth2
# importing initial version - gth
#
# ------------------------------

?>
