package au.com.showcase.application.client.ui.event;

import au.com.showcase.application.client.scroll.RegistrationForm;

import com.google.gwt.event.dom.client.ClickEvent;
import com.google.gwt.event.dom.client.ClickHandler;
import com.google.gwt.user.client.ui.CheckBox;

public class SubmitButtonClickHandler implements ClickHandler {

	private RegistrationForm registrationForm;

	private AlphabetTextBoxBlurHandler firstNameBlurHandler;

	private AlphabetTextBoxBlurHandler lastNameBlurHandler;

	private UsernameTextBoxBlurHandler userNameBlurHandler;

	private PasswordTextBoxBlurHandler passwordBlurHandler;

	private ConfirmPasswordTextBoxBlurHandler confirmPasswordBlurHandler;

	private MonthListBoxBlurHandler dobMonthBlurHandler;

	private DateTextBoxBlurHandler dobDateBlurHandler;

	public SubmitButtonClickHandler(
			AlphabetTextBoxBlurHandler firstNameBlurHandler,
			AlphabetTextBoxBlurHandler lastNameBlurHandler,
			UsernameTextBoxBlurHandler userNameBlurHandler,
			PasswordTextBoxBlurHandler passwordBlurHandler,
			ConfirmPasswordTextBoxBlurHandler confirmPasswordBlurHandler,
			MonthListBoxBlurHandler dobMonthBlurHandler,
			DateTextBoxBlurHandler dobDateBlurHandler,
			YearTextBoxBlurHandler dobYearBlurHandler,
			GenderListBoxBlurHandler genderBlurHandler,
			MobileNumberTextBoxBlurHandler mobileNumberBlurHandler,
			EmailAddressTextBoxBlurHandler emailAddressBlurHandler,
			LocationListBoxBlurHandler locationBlurHandler,
			CaptchaTextBoxBlurHandler captchaBlurHandler, CheckBox agreement) {

		this.agreement = agreement;
		this.captchaBlurHandler = captchaBlurHandler;
		this.confirmPasswordBlurHandler = confirmPasswordBlurHandler;
		this.dobDateBlurHandler = dobDateBlurHandler;
		this.dobMonthBlurHandler = dobMonthBlurHandler;
		this.dobYearBlurHandler = dobYearBlurHandler;
		this.emailAddressBlurHandler = emailAddressBlurHandler;
		this.firstNameBlurHandler = firstNameBlurHandler;
		this.genderBlurHandler = genderBlurHandler;
		this.lastNameBlurHandler = lastNameBlurHandler;
		this.locationBlurHandler = locationBlurHandler;
		this.mobileNumberBlurHandler = mobileNumberBlurHandler;
		this.passwordBlurHandler = passwordBlurHandler;
		this.userNameBlurHandler = userNameBlurHandler;

	}

	private YearTextBoxBlurHandler dobYearBlurHandler;

	private GenderListBoxBlurHandler genderBlurHandler;

	private MobileNumberTextBoxBlurHandler mobileNumberBlurHandler;

	private EmailAddressTextBoxBlurHandler emailAddressBlurHandler;

	private LocationListBoxBlurHandler locationBlurHandler;

	private CaptchaTextBoxBlurHandler captchaBlurHandler;

	private CheckBox agreement;

	@Override
	public void onClick(ClickEvent event) {

		if (!registrationForm.hasErrors()) {
			// Submit to server
		} else {
			// Still error persists, inform to user
		}

	}

	public SubmitButtonClickHandler() {

	}

	public AlphabetTextBoxBlurHandler getFirstNameBlurHandler() {
		return firstNameBlurHandler;
	}

	public void setFirstNameBlurHandler(
			AlphabetTextBoxBlurHandler firstNameBlurHandler) {
		this.firstNameBlurHandler = firstNameBlurHandler;
	}

	public AlphabetTextBoxBlurHandler getLastNameBlurHandler() {
		return lastNameBlurHandler;
	}

	public void setLastNameBlurHandler(
			AlphabetTextBoxBlurHandler lastNameBlurHandler) {
		this.lastNameBlurHandler = lastNameBlurHandler;
	}

	public UsernameTextBoxBlurHandler getUserNameBlurHandler() {
		return userNameBlurHandler;
	}

	public void setUserNameBlurHandler(
			UsernameTextBoxBlurHandler userNameBlurHandler) {
		this.userNameBlurHandler = userNameBlurHandler;
	}

	public PasswordTextBoxBlurHandler getPasswordBlurHandler() {
		return passwordBlurHandler;
	}

	public void setPasswordBlurHandler(
			PasswordTextBoxBlurHandler passwordBlurHandler) {
		this.passwordBlurHandler = passwordBlurHandler;
	}

	public ConfirmPasswordTextBoxBlurHandler getConfirmPasswordBlurHandler() {
		return confirmPasswordBlurHandler;
	}

	public void setConfirmPasswordBlurHandler(
			ConfirmPasswordTextBoxBlurHandler confirmPasswordBlurHandler) {
		this.confirmPasswordBlurHandler = confirmPasswordBlurHandler;
	}

	public MonthListBoxBlurHandler getDobMonthBlurHandler() {
		return dobMonthBlurHandler;
	}

	public void setDobMonthBlurHandler(
			MonthListBoxBlurHandler dobMonthBlurHandler) {
		this.dobMonthBlurHandler = dobMonthBlurHandler;
	}

	public DateTextBoxBlurHandler getDobDateBlurHandler() {
		return dobDateBlurHandler;
	}

	public void setDobDateBlurHandler(DateTextBoxBlurHandler dobDateBlurHandler) {
		this.dobDateBlurHandler = dobDateBlurHandler;
	}

	public YearTextBoxBlurHandler getDobYearBlurHandler() {
		return dobYearBlurHandler;
	}

	public void setDobYearBlurHandler(YearTextBoxBlurHandler dobYearBlurHandler) {
		this.dobYearBlurHandler = dobYearBlurHandler;
	}

	public GenderListBoxBlurHandler getGenderBlurHandler() {
		return genderBlurHandler;
	}

	public void setGenderBlurHandler(GenderListBoxBlurHandler genderBlurHandler) {
		this.genderBlurHandler = genderBlurHandler;
	}

	public MobileNumberTextBoxBlurHandler getMobileNumberBlurHandler() {
		return mobileNumberBlurHandler;
	}

	public void setMobileNumberBlurHandler(
			MobileNumberTextBoxBlurHandler mobileNumberBlurHandler) {
		this.mobileNumberBlurHandler = mobileNumberBlurHandler;
	}

	public EmailAddressTextBoxBlurHandler getEmailAddressBlurHandler() {
		return emailAddressBlurHandler;
	}

	public void setEmailAddressBlurHandler(
			EmailAddressTextBoxBlurHandler emailAddressBlurHandler) {
		this.emailAddressBlurHandler = emailAddressBlurHandler;
	}

	public LocationListBoxBlurHandler getLocationBlurHandler() {
		return locationBlurHandler;
	}

	public void setLocationBlurHandler(
			LocationListBoxBlurHandler locationBlurHandler) {
		this.locationBlurHandler = locationBlurHandler;
	}

	public CaptchaTextBoxBlurHandler getCaptchaBlurHandler() {
		return captchaBlurHandler;
	}

	public void setCaptchaBlurHandler(
			CaptchaTextBoxBlurHandler captchaBlurHandler) {
		this.captchaBlurHandler = captchaBlurHandler;
	}

	public CheckBox getAgreement() {
		return agreement;
	}

	public void setAgreement(CheckBox agreement) {
		this.agreement = agreement;
	}

	public RegistrationForm getRegistrationForm() {
		return registrationForm;
	}

	public void setRegistrationForm(RegistrationForm registrationForm) {
		this.registrationForm = registrationForm;
	}

}