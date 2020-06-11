GrayScale lightgray = GrayScale(18);
GrayScale darkgray  = GrayScale(6);
ColorCombination white_on_gray( &lightgray, &darkgray );

BasicColor repo_dirty_fg = BasicColor(7);
BasicColor repo_clean_fg = BasicColor(0);
Color256 repo_dirty_bg = Color256(4,0,1);
Color256 repo_clean_bg = Color256(3,4,0);
ColorCombination repo_dirty( &repo_dirty_fg, &repo_dirty_bg );
ColorCombination repo_clean( &repo_clean_fg, &repo_clean_bg );
ColorCombination repo_dirty_separator( &darkgray, &repo_dirty_bg );
ColorCombination repo_clean_separator( &darkgray, &repo_clean_bg );
