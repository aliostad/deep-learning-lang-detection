package com.video.domain.logic;

import com.video.service.EventService;
import com.video.service.GroupService;
import com.video.service.PlaybillService;
import com.video.service.SearchService;
import com.video.service.UserService;
import com.video.service.VideoCommentService;
import com.video.service.VideoService;
import com.video.service.VideoTagService;
import com.video.service.WhisperService;

public interface AllServiceFacade extends UserService, GroupService,
		VideoService, VideoTagService, SearchService, PlaybillService,
		VideoCommentService, WhisperService,EventService {

}
