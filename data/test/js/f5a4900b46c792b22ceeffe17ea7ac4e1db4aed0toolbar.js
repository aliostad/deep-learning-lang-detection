hui.ui.listen({
	$ready : function() {
		showStreetname.setValue(partToolbar.partForm.show_streetname.value);
		showCity.setValue(partToolbar.partForm.show_city.value);
		showCountry.setValue(partToolbar.partForm.show_country.value);
		showZipcode.setValue(partToolbar.partForm.show_zipcode.value);
		showFirstName.setValue(partToolbar.partForm.show_firstname.value);
		showMiddleName.setValue(partToolbar.partForm.show_middlename.value);
		showSurname.setValue(partToolbar.partForm.show_surname.value);
		showNickname.setValue(partToolbar.partForm.show_nickname.value);
		showInitials.setValue(partToolbar.partForm.show_initials.value);
		showSex.setValue(partToolbar.partForm.show_sex.value);
		showWebaddress.setValue(partToolbar.partForm.show_webaddress.value);
		showImage.setValue(partToolbar.partForm.show_image.value);
		showEmailPrivate.setValue(partToolbar.partForm.show_emailprivate.value);
		showEmailJob.setValue(partToolbar.partForm.show_emailjob.value);
		showPhonePrivate.setValue(partToolbar.partForm.show_phoneprivate.value);
		showPhoneJob.setValue(partToolbar.partForm.show_phonejob.value);
		alignment.setValue(partToolbar.partForm.align.value);
	},
	$valueChanged$alignment : function(value) {
		this.update();
	},
	$valueChanged$showFirstName : function(value) {
		this.update();
	},
	$valueChanged$showMiddleName : function(value) {
		this.update();
	},
	$valueChanged$showSurname : function(value) {
		this.update();
	},
	$valueChanged$showNickname : function(value) {
		this.update();
	},
	$valueChanged$showInitials : function(value) {
		this.update();
	},
	$valueChanged$showSex : function(value) {
		this.update();
	},
	$valueChanged$showCity : function(value) {
		this.update();
	},
	$valueChanged$showZipcode : function(value) {
		this.update();
	},
	$valueChanged$showStreetname : function(value) {
		this.update();
	},
	$valueChanged$showCountry : function(value) {
		this.update();
	},
	$valueChanged$showWebaddress : function(value) {
		this.update();
	},
	$valueChanged$showImage : function(value) {
		this.update();
	},
	$valueChanged$showEmailPrivate : function(value) {
		this.update();
	},
	$valueChanged$showEmailJob : function(value) {
		this.update();
	},
	$valueChanged$showPhonePrivate : function(value) {
		this.update();
	},
	$valueChanged$showPhoneJob : function(value) {
		this.update();
	},
	update : function() {
		partToolbar.partForm.align.value=alignment.getValue() || '';
		partToolbar.partForm.show_firstname.value=showFirstName.getValue();
		partToolbar.partForm.show_middlename.value=showMiddleName.getValue();
		partToolbar.partForm.show_surname.value=showSurname.getValue();
		partToolbar.partForm.show_nickname.value=showNickname.getValue();
		partToolbar.partForm.show_initials.value=showInitials.getValue();
		partToolbar.partForm.show_sex.value=showSex.getValue();
		partToolbar.partForm.show_streetname.value=showStreetname.getValue();
		partToolbar.partForm.show_city.value=showCity.getValue();
		partToolbar.partForm.show_zipcode.value=showZipcode.getValue();
		partToolbar.partForm.show_country.value=showCountry.getValue();
		partToolbar.partForm.show_webaddress.value=showWebaddress.getValue();
		partToolbar.partForm.show_image.value=showImage.getValue();
		partToolbar.partForm.show_emailprivate.value=showEmailPrivate.getValue();
		partToolbar.partForm.show_emailjob.value=showEmailJob.getValue();
		partToolbar.partForm.show_phoneprivate.value=showPhonePrivate.getValue();
		partToolbar.partForm.show_phonejob.value=showPhoneJob.getValue();
		partToolbar.preview();
	}
});