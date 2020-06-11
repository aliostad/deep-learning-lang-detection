package me.gteam.logman.service.impl;

import java.io.Serializable;
import java.util.Collection;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import me.gteam.logman.dao.HandlerDao;
import me.gteam.logman.domain.Handler;
import me.gteam.logman.service.HandlerService;

@Service("handlerService")
public class HandlerServiceImpl implements HandlerService{

	@Resource(name="handlerDao")
	private HandlerDao handlerDao;

	public void saveHandler(Handler handler) {
		this.handlerDao.saveEntry(handler);
	}

	public void updateHandler(Handler handler){
		this.handlerDao.updateEntry(handler);
	}

	public void deleteHandlerByID(Serializable id, String deleteMode) {
		this.handlerDao.deleteEntry(id);
	}

	public Collection<Handler> getAllHandler() {
		return this.handlerDao.getAllEntry();
	}

	public Handler getHandlerById(Serializable id) {
		return (Handler)this.handlerDao.getEntryById(id);
	}

}