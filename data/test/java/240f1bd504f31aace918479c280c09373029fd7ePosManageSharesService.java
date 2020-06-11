package gnete.card.service;

import gnete.card.entity.PosManageShares;
import gnete.etc.BizException;

public interface PosManageSharesService {
	/**
	 * 添加运营中心与机具维护方分润参数
	 * @param posManageShares
	 */
	public boolean addPosManageShares(PosManageShares[] feeArray, String sessionUserCode) throws BizException;
	
	/**
	 * 修改运营中心与机具维护方分润参数
	 * @param posManageShares
	 */
	public boolean modifyPosManageShares(PosManageShares posManageShares) throws BizException;
	
	/**
	 * 删除运营中心与机具维护方分润参数
	 * @param posManageShares
	 */
	public boolean deletePosManageShares(PosManageShares posManageShares) throws BizException;

}
