package com.syuesoft.sell.noteManage.serviceimpl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.syuesoft.fin.vo.Datagrid;
import com.syuesoft.sell.noteManage.dao.NoteManageDao;
import com.syuesoft.sell.noteManage.service.NoteManageService;
import com.syuesoft.sell.noteManage.vo.NoteManageVo;

@Service("noteManageService")
public class NoteManageServiceImpl implements NoteManageService {
	private NoteManageDao noteManageDao;

	public NoteManageDao getNoteManageDao() {
		return noteManageDao;
	}
	@Autowired
	public void setNoteManageDao(NoteManageDao noteManageDao) {
		this.noteManageDao = noteManageDao;
	}

	
	public Datagrid getCustomInfo(NoteManageVo noteManageVo) throws Exception {

		return noteManageDao.getCustomInfo(noteManageVo);
	}

}
