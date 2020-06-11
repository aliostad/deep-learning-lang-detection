namespace ShoppingList
{
    public class ApiUrls
    {
        private static string _drinkApiUri;
        private static string _drinksApiUri;

        public static void ResetApiUrls()
        {
            _drinkApiUri = null;
            _drinksApiUri = null;
        }

        public static string Drinks
            => _drinksApiUri ?? (_drinksApiUri = string.Concat(AppSettings.BaseApiUri, "/drinks"));

        public static string Drink
            => _drinkApiUri ?? (_drinkApiUri = string.Concat(AppSettings.BaseApiUri, "/drinks/{0}"));
    }
}