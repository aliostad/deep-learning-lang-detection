package com.abbcc.springrest.controller.user.site.piece;

import org.springframework.beans.factory.annotation.Autowired;

import com.abbcc.service.AlbumService;
import com.abbcc.service.AttachmentService;
import com.abbcc.service.CategoryService;
import com.abbcc.service.EnterpcontactService;
import com.abbcc.service.EnterpriseService;
import com.abbcc.service.GroupAnalysisService;
import com.abbcc.service.GroupGaimService;
import com.abbcc.service.GroupLaymodService;
import com.abbcc.service.GroupLayoutService;
import com.abbcc.service.GroupLaythemeService;
import com.abbcc.service.GroupModuleService;
import com.abbcc.service.GroupNavigatorService;
import com.abbcc.service.GroupSeoService;
import com.abbcc.service.GroupThemeService;
import com.abbcc.service.GroupUserdefinedService;
import com.abbcc.service.GroupWidthService;
import com.abbcc.service.LinkService;
import com.abbcc.service.NewsService;
import com.abbcc.service.ProductService;
import com.abbcc.service.SupplyService;
import com.abbcc.service.SyscodeService;
import com.abbcc.service.UserService;
import com.abbcc.springrest.controller.user.site.BaseSiteController;

public class AutowiredService<T> extends BaseSiteController<T> {
	private static final long serialVersionUID = 1L;
	@Autowired
	protected UserService userService;
	@Autowired
	protected CategoryService categoryService;
	@Autowired
	protected ProductService productService;
	@Autowired
	protected LinkService linkService;
	@Autowired
	protected AttachmentService attachmentService;
	@Autowired
	protected SupplyService supplyService;
	@Autowired
	protected EnterpcontactService enterpcontactService;
	@Autowired
	protected NewsService newsService;
	@Autowired
	protected SyscodeService syscodeService;
	@Autowired
	protected EnterpriseService enterpriseService;
	@Autowired
	protected AlbumService albumService;
	@Autowired
	protected GroupLayoutService layoutService;
	@Autowired
	protected GroupLaymodService laymodService;
	@Autowired
	protected GroupModuleService moduleService;
	@Autowired
	protected GroupLaythemeService laythemeService;
	@Autowired
	protected GroupThemeService themeService;
	@Autowired
	protected GroupNavigatorService navigatorService;
	@Autowired
	protected GroupWidthService widthService;
	@Autowired
	protected GroupUserdefinedService userDefinedService;
	@Autowired
	protected GroupGaimService gaimService;
	@Autowired
	protected GroupAnalysisService analysisService;
	@Autowired
	protected GroupSeoService seoService;

}
