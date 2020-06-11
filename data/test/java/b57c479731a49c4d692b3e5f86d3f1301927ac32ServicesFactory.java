package ajman.university.grad.project.eventshare.common.services;

import ajman.university.grad.project.eventshare.common.contracts.IAlarmService;
import ajman.university.grad.project.eventshare.common.contracts.IErrorService;
import ajman.university.grad.project.eventshare.common.contracts.ILocalNotificationService;
import ajman.university.grad.project.eventshare.common.contracts.ILocalStorageService;
import ajman.university.grad.project.eventshare.common.contracts.IRemoteNotificationService;
import ajman.university.grad.project.eventshare.common.contracts.ITagService;

public class ServicesFactory {
	private static ILocalStorageService _localStorageService;
	private static ITagService _tagService;
	private static IErrorService _errorService;
	private static ILocalNotificationService _localNotificationService;
	private static IRemoteNotificationService _remoteNotificationService;
	private static IAlarmService _alarmService;
	
	public static ILocalStorageService getLocalStorageService() {
		if (_localStorageService == null) {
			_localStorageService = new LocalStorageService();
		}
		
		return _localStorageService;
	}

	public static ITagService getFakeNfcTagService() {
		if (_tagService == null) {
			_tagService = new FakeNfcTagService();
		}
		
		return _tagService;
	}
	
	public static IErrorService getErrorService() {
		if (_errorService == null) {
			_errorService = new ErrorService();
		}
		
		return _errorService;
	}
	
	public static ILocalNotificationService getLocalNotificationService() {
		if (_localNotificationService == null) {
			_localNotificationService = new LocalNotificationService();
		}
		
		return _localNotificationService;
	}
	
	public static IRemoteNotificationService getRemoteNotificationService() {
		if (_remoteNotificationService == null) {
			_remoteNotificationService = new RemoteNotificationService();
		}
		
		return _remoteNotificationService;
	}
	
	public static IAlarmService getAlarmService() {
		if (_alarmService == null) {
			_alarmService = new AlarmService();
		}
		
		return _alarmService;
	}
}
