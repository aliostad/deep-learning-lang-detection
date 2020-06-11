package xmc.cineplex.service.bean;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import xmc.cineplex.dao.ConsumptionDao;
import xmc.cineplex.dao.PlanDao;
import xmc.cineplex.dao.SeatDao;
import xmc.cineplex.dao.TicketManageDao;
import xmc.cineplex.model.Plan;
import xmc.cineplex.model.TicketManage;
import xmc.cineplex.service.TicketService;
@Service
public class TicketServiceBean implements TicketService {
	@Autowired
	private TicketManageDao ticketManageDaoImpl;
	@Autowired
	private SeatDao seatDaoImpl;
	
	public void createTicketManage(TicketManage ticketManage) {
		ticketManageDaoImpl.createTicketManage(ticketManage);
	}

	
	public TicketManage getTicketMange(int pid) {
		return ticketManageDaoImpl.getTicketManage(pid);
	}

	
	public void soldTicket(int pid, int amount) {
		ticketManageDaoImpl.soldTicket(pid, amount);
	}


	
	public void setbook(int id, int row, int col) {
		seatDaoImpl.setbook(id, row, col);
		
	}



}
