package com.sunlights.op.service;

import com.sunlights.common.vo.PageVo;
import com.sunlights.op.vo.FundManageVo;

import java.util.List;

/**
 * <p>Project: OperationPlatform</p>
 * <p>Title: FundManageService.java</p>
 * <p>Description: </p>
 * <p>Copyright (c) 2014 Sunlights.cc</p>
 * <p>All Rights Reserved.</p>
 *
 * @author <a href="mailto:zhencai.yuan@sunlights.cc">yuanzhencai</a>
 */
public interface FundManageService {
    public List<FundManageVo> findFundsBy(PageVo pageVo);

    public void create(FundManageVo fundManageVo);

    public void update(FundManageVo fundManageVo);

    public void delete(FundManageVo fundManageVo);
}
