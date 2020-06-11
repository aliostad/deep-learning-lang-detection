namespace TravelAgencyController.Controller
{
    public static class ControllerFactory
    {
        public static IAirlineController CreateAirlineController()
        {
            return new AirlineController();
        }

        public static IHotelController CreateHotelController()
        {
            return new HotelController();
        }

        public static IManageTourController CreateManageTourController()
        {
            return new ManageTourController();
        }

        public static IOrderController CreateOrderController()
        {
            return new OrderController();
        }
    }
}