package businessLogicService.repositoryBLService;

import java.util.List;

import vo.repositoryVO.OutRepositoryVO;
import vo.transitionVO.TransferringVO;

/**
 * description:业务逻辑层为中转中心仓库出库信息界面提供的服务
 * @author 阮威威
 * */
public interface OutRepositoryBLService {

	/**
	 * description:添加新的出库单信息
	 * 前置条件：用户按照界面输入OutRepositoryVO的信息，界面传递OutRepositoryVO
	 * 后置条件：系统保存出库单信息，返回界面是否保存成功
	 * 需接口：OutRepositoryDataService.AddOutRepositoryFormmDT(OutRepositoryPO outRepositoryPO)，
	 * OutRepositoryDataService.UpdateRepositoryInfoDT(OutRepositoryPO outRepository)
	 * @param OutRepositoryVO ,出库单信息的相关值对象，具体参照OutRepositoryVO的定义
	 * @return boolean, 返回出库单信息是否添加成功
	 * */
	public boolean addOutRepositoryFormBL(OutRepositoryVO outRepositoryVO);
	
	/**
	 * description:修改新的出库单信息
	 * 前置条件：用户按照界面输入OutRepositoryVO的信息，界面传递OutRepositoryVO
	 * 后置条件：系统保存修改的出库单信息，返回界面是否修改成功
	 * 需接口：OutRepositoryDataService.ModifyInRepositoryFormDT(OutRepositoryPO outRepositoryPO),
	 * OutRepositoryDataService.UpdateRepositoryInfoDT(OutRepositoryPO outRepository)
	 * @param OutRepositoryVO ,出库单信息的相关值对象，具体参照OutRepositoryVO的定义
	 * @return boolean, 返回出库单信息是否修改成功
	 * */
	public boolean modifyOutRepositoryFormBL(OutRepositoryVO outRepositoryVO);
	
	/**
	 * description:通过出库单的快递编号得到相应的出库单信息
	 * 前置条件：用户输入有效快递编号
	 * 后置条件：根据快递编号查找相应出库单信息，返回给界面显示
	 * 需接口：OutRepositoryDataService.FindOutRepositoryFormDT(String outRepositoryNumber)（根据快递编号查询入库单）
	 * @param OutRepositoryNumber ,快递编号（四位数字）
	 * @return OutRepositoryVO, 返回出库单信息的值对象，具体参照OutRepositoryVO的定义
	 * */
	public OutRepositoryVO findOutRepositoryFormBL(String OutRepositoryNumber);
	
	/**
	 * description:查看中转单列表信息
	 * 前置条件：用户请求进行中转单列表的查看
	 * 后置条件：系统返回中转单信息列表List<TransferringVO>（详细参数参照TransferringVO）给界面
	 * 需接口：TransferringBLService. List<RepositoryVO> getRepositoryInfo()
	 * @param data:查询某天的中转单列表
	 * @return List<TransferringVO>, 返回中转单列表信息的值对象，具体参照TransferringVO
	 * */
	public List<TransferringVO> GetTransferringInfo(String date);
	/**
	 * description:判断输入是否正确
	 * 前置条件：InRepositoryPanel
	 * 后置条件：返回是否正确
	 * 需接口：无
	 * @param outRepository,输入的出库单
	 * @return boolean ,返回是否正确
	 * */
	public boolean verify(OutRepositoryVO outRepositoryVO);
}
