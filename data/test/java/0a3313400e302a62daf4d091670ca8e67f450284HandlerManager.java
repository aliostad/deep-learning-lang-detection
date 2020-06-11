package com.infoklinik.rsvp.client;

import com.google.gwt.event.dom.client.ClickHandler;

public class HandlerManager {
	
	private ClickHandler addHandler;
	private ClickHandler showHandler;
	private ClickHandler showMoreHandler;
	private ClickHandler updateHandler;
	private ClickHandler deleteHandler;
	private ClickHandler likeHandler;
	private ClickHandler commentHandler;

	public ClickHandler getShowHandler() {
		return showHandler;
	}

	public void setShowHandler(ClickHandler showHandler) {
		this.showHandler = showHandler;
	}

	public ClickHandler getShowMoreHandler() {
		return showMoreHandler;
	}

	public void setShowMoreHandler(ClickHandler showMoreHandler) {
		this.showMoreHandler = showMoreHandler;
	}

	public ClickHandler getAddHandler() {
		return addHandler;
	}

	public void setAddHandler(ClickHandler addHandler) {
		this.addHandler = addHandler;
	}

	public ClickHandler getUpdateHandler() {
		return updateHandler;
	}

	public void setUpdateHandler(ClickHandler updateHandler) {
		this.updateHandler = updateHandler;
	}

	public ClickHandler getDeleteHandler() {
		return deleteHandler;
	}

	public void setDeleteHandler(ClickHandler deleteHandler) {
		this.deleteHandler = deleteHandler;
	}

	public ClickHandler getLikeHandler() {
		return likeHandler;
	}

	public void setLikeHandler(ClickHandler likeHandler) {
		this.likeHandler = likeHandler;
	}

	public ClickHandler getCommentHandler() {
		return commentHandler;
	}

	public void setCommentHandler(ClickHandler commentHandler) {
		this.commentHandler = commentHandler;
	}
}
