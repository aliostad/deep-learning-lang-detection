package ua.com.hotel.editor;

import java.beans.PropertyEditorSupport;

import ua.com.hotel.entity.RoomService;
import ua.com.hotel.service.RoomServiceService;

public class RoomServiceEditor extends PropertyEditorSupport{
	
	private final RoomServiceService roomServiceService;

	public RoomServiceEditor(RoomServiceService roomServiceService) {
		super();
		this.roomServiceService = roomServiceService;
	}

	@Override
	public void setAsText(String text) throws IllegalArgumentException {
		RoomService roomService = roomServiceService.findOne(Long.valueOf(text));
		setValue(roomService);
	}
}