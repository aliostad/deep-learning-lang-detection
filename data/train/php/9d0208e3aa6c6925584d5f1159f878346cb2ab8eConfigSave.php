<?php

/**************************************************************************/
/* PHP-Nuke CE: Web Portal System                                         */
/* ==============================                                         */
/*                                                                        */
/* Copyright (c) 2011 by Kevin Atwood                                     */
/* http://www.nukece.com                                                  */
/*                                                                        */
/* All PHP-Nuke CE code is released under the GNU General Public License. */
/* See CREDITS.txt, COPYRIGHT.txt and LICENSE.txt.                        */
/**************************************************************************/

downloads_save_config("admperpage",$xadmperpage);
downloads_save_config("blockunregmodify",$xblockunregmodify);
downloads_save_config("dateformat",$xdateformat);
downloads_save_config("mostpopular",$xmostpopular);
downloads_save_config("mostpopulartrig",$xmostpopulartrig);
downloads_save_config("perpage",$xperpage);
downloads_save_config("popular",$xpopular);
downloads_save_config("results",$xresults);
downloads_save_config("show_download",$xshow_download);
downloads_save_config("show_links_num",$xshow_links_num);
downloads_save_config("usegfxcheck",$xusegfxcheck);
redirect($admin_file.".php?op=DLConfig");

?>