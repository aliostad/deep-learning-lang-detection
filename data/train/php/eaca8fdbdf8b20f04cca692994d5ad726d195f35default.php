<?php

/* BEGIN BIBLE CONTAINNER */
$bovp_show_theme = "<div class='bovp_container'>";

	/* BEGIN HEADER CONTAINNER */
	$bovp_show_theme .= "<div class='bovp_header bovp_clear'>";

		/* SEARCH FORM CONTAINER */
		$bovp_show_theme .= $bovp->showFormSearch();

		$bovp_show_theme .= "<div class='bovp_tools'>";
			/* SHOW SHARE BUTTONS */
			$bovp_show_theme .= $bovp->showShareButtons(bovpSharer(bovpWriteUrl()));
			/* SHOW INCREASE/DECREASE FONT BUTTONS */
			$bovp_show_theme .= $bovp->showFontSize();
		
		$bovp_show_theme .= "</div>";
		
	$bovp_show_theme .= "</div>";

	/* TITLE */
	$bovp_show_theme .= $bovp->showTitle(strtolower($bovp_title));

	/* BIBLE TEXT CONTAINNER */
	$bovp_show_theme .= $bovp->showResults($bovp_content);

	/* PAGINATION CONTAINNER */
	$bovp_show_theme .= "<nav class='bovp_pagination bovp_clear'>";

		/* SHOW PAGINATION */
		$bovp_show_theme .= $bovp->showPagination();
		
	$bovp_show_theme .= "</nav>";

	/* FOOTER CONTAINNER */
	$bovp_show_theme .= "<div class='bovp_footer bovp_clear'>";

		$bovp_show_theme .= "<div class='bovp_version bovp_clear'>";

			$bovp_show_theme .= $bovp->showVersion();

		$bovp_show_theme .= "</div>";

		$bovp_show_theme .= "<div class='bovp_logo bovp_clear'>";

			$bovp_show_theme .= $bovp->showLogo();

		$bovp_show_theme .= "</div>";

	$bovp_show_theme .= "</div>";

/* END BIBLE CONTAINNER */
$bovp_show_theme .= "</div>";

?>