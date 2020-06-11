/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.lorent.lvmc.service;

/**
 *
 * @author jack
 */
public class ServiceFactory {
    private LoginService loginService;
    private ConfService confService;
    private ShareFileService shareFileService;
    private VoteService voteService;
    private ScreenShareService screenShareService;

    public ScreenShareService getScreenShareService() {
        return screenShareService;
    }

    public void setScreenShareService(ScreenShareService screenShareService) {
        this.screenShareService = screenShareService;
    }

    public ShareFileService getShareFileService() {
        return shareFileService;
    }

    public void setShareFileService(ShareFileService shareFileService) {
        this.shareFileService = shareFileService;
    }

    public VoteService getVoteService() {
        return voteService;
    }

    public void setVoteService(VoteService voteService) {
        this.voteService = voteService;
    }
    
    public ConfService getConfService() {
        return confService;
    }

    public void setConfService(ConfService confService) {
        this.confService = confService;
    }
            
    public LoginService getLoginService() {
        return loginService;
    }

    public void setLoginService(LoginService loginService) {
        this.loginService = loginService;
    }
    
}
