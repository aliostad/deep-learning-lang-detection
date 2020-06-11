package ua.com.hotel.editor;

import java.beans.PropertyEditorSupport;

import ua.com.hotel.entity.AditionalService;
import ua.com.hotel.service.AditionalServiceService;

public class AditionalServiceEditor extends PropertyEditorSupport{
	
	private final AditionalServiceService aditionalServiceService;
	
	public AditionalServiceEditor(
			AditionalServiceService aditionalServiceService) {
		this.aditionalServiceService = aditionalServiceService;
	}

	@Override
	public void setAsText(String text) throws IllegalArgumentException {
		AditionalService aditionalService = aditionalServiceService.findOne(Long.valueOf(text));
		setValue(aditionalService);
	}
	
}
