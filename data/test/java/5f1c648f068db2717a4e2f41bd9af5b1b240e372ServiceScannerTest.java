/**
 * Project: phoenix-router
 * 
 * File Created at 2013-4-12
 * $Id$
 * 
 * Copyright 2010 dianping.com.
 * All rights reserved.
 *
 * This software is the confidential and proprietary information of
 * Dianping Company. ("Confidential Information").  You shall not
 * disclose such Confidential Information and shall use it only in
 * accordance with the terms of the license agreement you entered into
 * with dianping.com.
 */
package com.dianping.phoenix.dev.core.tools.scanner;

import java.util.Arrays;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.junit.Assert;
import org.junit.Test;

import com.dianping.phoenix.dev.core.tools.scanner.Scanner;
import com.dianping.phoenix.dev.core.tools.scanner.ServiceScanner;

/**
 * TODO Comment of ServiceScannerTest
 * 
 * @author Leo Liang
 * 
 */
public class ServiceScannerTest {
    @Test
    public void test() {
        List<String> expected = Arrays.asList(new String[] {
                "http://service.dianping.com/groupService/eventService_1.0.0",
                "http://service.dianping.com/groupService/eventTypeService_1.0.0",
                "http://service.dianping.com/groupService/eventNoteService_1.0.0",
                "http://service.dianping.com/groupService/eventUserService_1.0.0",
                "http://service.dianping.com/groupService/groupUserService_1.0.0",
                "http://service.dianping.com/groupService/groupUserHonorTitleService_1.0.0",
                "http://service.dianping.com/groupService/groupUserScoreLevelService_1.0.0",
                "http://service.dianping.com/groupService/groupService_1.0.0",
                "http://service.dianping.com/groupService/groupLinkService_1.0.0",
                "http://service.dianping.com/groupService/groupNoteTypeService_1.0.0",
                "http://service.dianping.com/groupService/groupTypeApplyService_1.0.0",
                "http://service.dianping.com/groupService/groupCategoryService_1.0.0",
                "http://service.dianping.com/groupService/groupRecommendService_1.0.0",
                "http://service.dianping.com/groupService/groupMedalService_1.0.0",
                "http://service.dianping.com/groupService/userGroupInfoService_1.0.0",
                "http://service.dianping.com/groupService/groupNoteService_1.0.0",
                "http://service.dianping.com/groupService/groupNoteScoreLogService_1.0.0",
                "http://service.dianping.com/groupService/groupOperateLogService_1.0.0",
                "http://service.dianping.com/groupService/groupDCashLogService_1.0.0",
                "http://service.dianping.com/groupService/groupFollowNoteService_1.0.0",
                "http://service.dianping.com/groupService/groupSurveyService_1.0.0",
                "http://service.dianping.com/groupService/groupSurveyMemberService_1.0.0",
                "http://service.dianping.com/groupService/groupbackService_1.0.0",
                "http://service.dianping.com/groupService/groupRoleService_1.0.0",
                "http://service.dianping.com/groupService/groupPicService_1.0.0",
                "http://service.dianping.com/groupService/groupUserScoreDailyLogService_1.0.0",
                "http://service.dianping.com/groupService/groupUserScoreSumService_1.0.0",
                "http://service.dianping.com/groupService/eventShopService_1.0.0",
                "http://service.dianping.com/groupService/groupIndexService_1.0.0",
                "http://service.dianping.com/groupService/groupNoteCountService_1.0.0",
                "http://service.dianping.com/groupService/groupCheckInActivityService_1.0.0",
                "http://service.dianping.com/groupService/noteVerifyFeedbackService_1.0.0",
                "http://service.dianping.com/groupService/eventFollowNoteService_1.0.0",
                "http://service.dianping.com/groupService/groupQAUserService_1.0.0",
                "http://service.dianping.com/groupService/groupSetService_1.0.0",
                "http://service.dianping.com/groupService/groupQAFollowNoteService_1.0.0",
                "http://service.dianping.com/groupService/groupQANoteService_1.0.0",
                "http://service.dianping.com/groupService/groupNoteHideContentService_1.0.0",
                "http://service.dianping.com/groupService/groupNoteShopService_1.0.0",
                "http://service.dianping.com/groupService/groupConfigurationService_1.0.0",
                "http://service.dianping.com/groupService/userGoldService_1.0.0",
                "http://service.dianping.com/groupService/userGoldDetailService_1.0.0",
                "http://service.dianping.com/groupService/groupFollowNoteExtInfoService_1.0.0",
                "http://service.dianping.com/groupService/userGoldExchangeService_1.0.0",
                "http://service.dianping.com/groupService/groupNoteExtInfoService_1.0.0",
                "http://service.dianping.com/groupService/hotNoteService_1.0.0",
                "http://service.dianping.com/groupService/goldEggService_1.0.0" });
        Scanner<String> scanner = new ServiceScanner();
        Assert.assertTrue(expected.equals(scanner.scan(FileUtils.toFile(this.getClass().getResource("service.xml")))));
    }

    @Test
    public void testhasNoService() {
        Scanner<String> scanner = new ServiceScanner();
        Assert.assertTrue(scanner.scan(FileUtils.toFile(this.getClass().getResource("service-none.xml"))).isEmpty());
    }
}
