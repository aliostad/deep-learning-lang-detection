using MWSSubscriptionsService.Model;

namespace VendorManagement.Resources.DAL.Amazon.Contracts
{
    public interface IMWSSubscriptionsServiceWrapper
    {
        CreateSubscriptionResponse InvokeCreateSubscription();

        DeleteSubscriptionResponse InvokeDeleteSubscription();

        DeregisterDestinationResponse InvokeDeregisterDestination();

        GetSubscriptionResponse InvokeGetSubscription();

        ListRegisteredDestinationsResponse InvokeListRegisteredDestinations();

        ListSubscriptionsResponse InvokeListSubscriptions(ListSubscriptionsInput request);

        RegisterDestinationResponse InvokeRegisterDestination();

        SendTestNotificationToDestinationResponse InvokeSendTestNotificationToDestination();

        UpdateSubscriptionResponse InvokeUpdateSubscription();

        GetServiceStatusResponse InvokeGetServiceStatus();

    }
}
