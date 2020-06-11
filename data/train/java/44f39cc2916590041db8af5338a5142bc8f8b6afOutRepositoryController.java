package businessLogic.businessLogicController.repositoryController;

import java.util.List;

import businessLogic.businessLogicController.transitionController.TransferringController;
import businessLogic.businessLogicModel.repositoryModel.OutRepository;
import businessLogicService.repositoryBLService.OutRepositoryBLService;
import businessLogicService.transitionBLService.TransferringBLService;
import vo.repositoryVO.OutRepositoryVO;
import vo.transitionVO.TransferringVO;

public class OutRepositoryController implements OutRepositoryBLService{
	TransferringBLService transferringBLService = new TransferringController();
	OutRepository outRepository = new OutRepository();

	public boolean addOutRepositoryFormBL(OutRepositoryVO outRepositoryVO) {
		// TODO Auto-generated method stub
		return outRepository.addOutRepositoryFormBL(outRepositoryVO);
	}

	public boolean modifyOutRepositoryFormBL(OutRepositoryVO outRepositoryVO) {
		// TODO Auto-generated method stub
		return outRepository.modifyOutRepositoryFormBL(outRepositoryVO);
	}

	public OutRepositoryVO findOutRepositoryFormBL(String OutRepositoryNumber) {
		// TODO Auto-generated method stub
		return outRepository.findOutRepositoryFormBL(OutRepositoryNumber);
	}

	public List<TransferringVO> GetTransferringInfo(String date) {
		// TODO Auto-generated method stub
		return transferringBLService.GetTansferringInfoBL(date);
	}

	@Override
	public boolean verify(OutRepositoryVO outRepositoryVO) {
		// TODO Auto-generated method stub
		return outRepository.verify(outRepositoryVO);
	}

}
