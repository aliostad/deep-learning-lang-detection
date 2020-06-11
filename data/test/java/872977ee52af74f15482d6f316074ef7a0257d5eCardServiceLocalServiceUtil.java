/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.vss.cardservice.service.util;

import com.vss.cardservice.api.IGameAccountService;
import com.vss.cardservice.api.IIssuerService;
import com.vss.cardservice.api.ITransactionService;

/**
 *
 * @author zannami
 */
public class CardServiceLocalServiceUtil {

    static ITransactionService transactionService;
    static IGameAccountService gameAccountService;
    static IIssuerService issuerService;

    public static IIssuerService getIssuerService() {
        return issuerService;
    }

    public void setIssuerService(IIssuerService issuerService) {
        CardServiceLocalServiceUtil.issuerService = issuerService;
    }

    public static IGameAccountService getGameAccountService() {
        return gameAccountService;
    }

    public void setGameAccountService(IGameAccountService gameAccountService) {
        CardServiceLocalServiceUtil.gameAccountService = gameAccountService;
    }

    public static ITransactionService getTransactionService() {
        return transactionService;
    }

    public void setTransactionService(ITransactionService transactionService) {
        CardServiceLocalServiceUtil.transactionService = transactionService;
    }
}
