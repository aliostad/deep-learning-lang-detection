CREATE VIEW [View_Newsletter_LinkClickedBy] AS
SELECT  Newsletter_SubscriberLink.LinkID, 
		View_NewsletterSubscriberUserRole_Joined.SubscriberID, 
        View_NewsletterSubscriberUserRole_Joined.SubscriberFullName, 
        ISNULL(View_NewsletterSubscriberUserRole_Joined.SubscriberEmail, View_NewsletterSubscriberUserRole_Joined.Email) AS SubscriberEmail, 
        Newsletter_SubscriberLink.Clicks,
        View_NewsletterSubscriberUserRole_Joined.SubscriberSiteID AS SiteID
FROM    Newsletter_SubscriberLink LEFT OUTER JOIN
        View_NewsletterSubscriberUserRole_Joined ON Newsletter_SubscriberLink.SubscriberID = View_NewsletterSubscriberUserRole_Joined.SubscriberID        
GO
