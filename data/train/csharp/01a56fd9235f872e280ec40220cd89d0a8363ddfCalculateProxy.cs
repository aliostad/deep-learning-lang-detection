namespace Proxy
{
    /// <summary>
    /// Заместитель. Реализует методы реального класса
    /// </summary>
    internal class CalculateProxy : ICalculate
    {
        private Calculate _calculate;

        public CalculateProxy()
        {
            _calculate = null;
        }


        public double Sum(double x, double y)
        {
            if (_calculate == null)
                _calculate = new Calculate();
            return _calculate.Sum(x, y);
        }

        public double Sub(double x, double y)
        {
            if (_calculate == null)
                _calculate = new Calculate();
            return _calculate.Sub(x, y);
        }


        public double Mult(double x, double y)
        {
            if (_calculate == null)
                _calculate = new Calculate();
            return _calculate.Mult(x, y);
        }

        public double Div(double x, double y)
        {
            if (_calculate == null)
                _calculate = new Calculate();
            return _calculate.Div(x, y);
        }
    }
}
