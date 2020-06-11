using System;

namespace Dispatch.Core
{
    public class DispatchViewModel
    {
        public string OrderId { get; set; }
        public string Email { get; set; }
        public DateTime DispatchTime { get; set; }
        public string ShippingAddress { get; set; }

        public DispatchViewModel(string orderId, string email, DateTime dispatchTime, string shippingAddress)
        {
            OrderId = orderId;
            Email = email;
            DispatchTime = dispatchTime;
            ShippingAddress = shippingAddress;
        }
    }
}