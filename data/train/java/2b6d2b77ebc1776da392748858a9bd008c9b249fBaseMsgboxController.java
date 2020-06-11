package com.cangshudoudou.msgbox.springmvc.controller;


import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.cangshudoudou.msgbox.service.CategoryService;
import com.cangshudoudou.msgbox.service.MessageService;

public class BaseMsgboxController extends MultiActionController {
    protected CategoryService categoryService;

    protected MessageService messageService;

    public CategoryService getCategoryService() {
        return categoryService;
    }

    public void setCategoryService(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    public MessageService getMessageService() {
        return messageService;
    }

    public void setMessageService(MessageService messageService) {
        this.messageService = messageService;
    }
}
