package com.ecg.servicefactory;

import com.ecg.services.FeedbackService;
import com.ecg.services.GuideService;
import com.ecg.services.LoginService;
import com.ecg.services.RegistrationService;
import com.ecg.services.GuideRegistrationService;
import com.ecg.services.UserService;
import com.ecg.services.ViewAnswerService;
import com.ecg.services.ViewAwardsService;
import com.ecg.services.ViewPaymentsService;
import com.ecg.services.ViewQuestionService;

public class ServiceFactory {

    private static LoginService loginService = null;
    private static RegistrationService registrationService=null;
    
    private static GuideRegistrationService guideregistrationService=null;
    private static UserService userService=null;
    private static ViewQuestionService  viewQuestionService=null;
    private static ViewAnswerService viewAnswerService=null;
    private static GuideService guideService=null;
    private static FeedbackService feedbackService=null;
    private static ViewAwardsService viewAwardsService=null;
    private static ViewPaymentsService viewPaymentsService=null;
    
    public static LoginService getLoginService( )
    {
    	
        if(loginService==null)
        {
            loginService= new LoginService( );
        }
        else{
            return loginService;
        }
        return loginService;
    }
    
    public static RegistrationService getRegistrationService( ){
    	
        if(registrationService==null){
            registrationService= new RegistrationService( );
        }
        else{
            return registrationService;
        }
        return registrationService;
    }
    
   
    
    public static GuideRegistrationService getGuideRegistrationService( ){
        if(guideregistrationService==null){
            guideregistrationService= new GuideRegistrationService( );
        }
        else{
            return guideregistrationService;
        }
        return guideregistrationService;
    }
    
 public static UserService getUserService()
 {
	 if(userService==null)
	 {
		 userService=new UserService();
	}
	 else
	 {
      return userService;
	 }
     return userService;
}
 public static GuideService getGuideService()
 {
	 if(guideService==null)
	 {
		 guideService=new GuideService();
	}
	 else
	 {
      return guideService;
	 }
     return guideService;
}
    public static ViewQuestionService getViewQuestionService()
    {
           if(viewQuestionService==null)
           {
            viewQuestionService=new ViewQuestionService();
           }
           else
      	 {
            return viewQuestionService;
      	 }       
           return viewQuestionService;
    }
    
    public static ViewAnswerService getAnswerService()
    {
    	if(viewAnswerService==null)
    	{
    		viewAnswerService = new ViewAnswerService();
    	}
    	else
    	{
    		return viewAnswerService;
    	}
    	return viewAnswerService;
    }
    public static FeedbackService getFeedBackService()
    {
    	if(feedbackService==null)
    	{
             feedbackService=new FeedbackService();
    	}
    	else
    	{
    		return feedbackService;
    	}
    	
    	return feedbackService;
}
    public static ViewAwardsService getAwardService()
    {
    	if(viewAwardsService==null)
    	{
    		viewAwardsService = new ViewAwardsService();
    	}
    	else
    	{
    		return viewAwardsService;
    	}
    	return viewAwardsService;
    }

    public static ViewPaymentsService getviewPaymentsService()
    {
    	if(viewPaymentsService==null)
    	{
    		viewPaymentsService = new ViewPaymentsService();
    	}
    	else
    	{
    		return viewPaymentsService;
    	}
    	return viewPaymentsService;
    }
}