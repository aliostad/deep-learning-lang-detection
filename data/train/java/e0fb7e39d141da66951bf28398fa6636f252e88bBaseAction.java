package net.eleword.blog.action;

import net.eleword.blog.service.*;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * TODO 此处填写 class 信息
 *
 * @author krisjin
 * @date 2014-2-17上午9:20:44
 */

public class BaseAction {

    @Autowired
    public NewsService newsService;

    @Autowired
    public ArticleService articleService;

    @Autowired
    public CategoryService categoryService;

    @Autowired
    public CommentService commentService;

    @Autowired
    public UserService userService;

    @Autowired
    public BlogService blogService;

    @Autowired
    public FolderService folderService;

    @Autowired
    public ColorService colorService;

}
