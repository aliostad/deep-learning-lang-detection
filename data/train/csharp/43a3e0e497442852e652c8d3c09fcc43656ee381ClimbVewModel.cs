using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Q400Calculator.Models;
using Q400Calculator.Data;
using Q400Calculator.Controllers;
using Q400Calculator.Interfaces;

namespace Q400Calculator.Models.CalculatorViewModels
{
    public class ClimbVewModel : ClimbData , CalculateInterface
    {
        
        CalculateInterface Calculate { get; }

        int CalculateInterface.heading
        {
            get
            {
                return Calculate.heading;
            }

            set
            {
                Calculate.heading = value;
            }
        }

        int CalculateInterface.windSpeed
        {
            get
            {
                return Calculate.windSpeed;
            }

            set
            {
                Calculate.windSpeed = value;
            }
        }

        int CalculateInterface.windDirection
        {
            get
            {
                return Calculate.windDirection;
            }

            set
            {
                Calculate.windDirection = value;
            }
        }

        int CalculateInterface.distance
        {
            get
            {
                return Calculate.distance;
            }

            set
            {
                Calculate.distance = value;
            }
        }

        int CalculateInterface.fuel
        {
            get
            {
                return Calculate.fuel;
            }

            set
            {
                Calculate.fuel = value;
            }
        }

        bool CalculateInterface.rain
        {
            get
            {
                return Calculate.rain;
            }

            set
            {
                Calculate.rain = value;
            }
        }

        bool CalculateInterface.snow
        {
            get
            {
                return Calculate.snow;
            }

            set
            {
                Calculate.snow = value;
            }
        }

        bool CalculateInterface.icing
        {
            get
            {
                return Calculate.icing;
            }

            set
            {
                Calculate.icing = value;
            }
        }

        bool CalculateInterface.headwind
        {
            get
            {
                return Calculate.headwind;
            }

            set
            {
                Calculate.headwind = value;
            }
        }

        bool CalculateInterface.tailwind
        {
            get
            {
                return Calculate.tailwind;
            }

            set
            {
                Calculate.tailwind = value;
            }
        }

        int heading;
        int windSpeed;
        int windDirection;
        int distance;
        int fuel;
        bool rain;
        bool snow;
        bool icing;
        bool headwind;
        bool tailwind;
        
        public ClimbVewModel(int weight, int vfri5, int vfri10,
                             int vfri15, int vClmb)
                             :base( weight, vfri5, vfri10, vfri15, vClmb)
        {
            if(rain == true)
            {

            }
            if(snow == true)
            {

            }
            if(icing == true)
            {
                Vfri5 = vfri5 + 20;
                vfri10 = vfri10 + 20;
                Vfri15 = vfri15 + 20;
                Vclmb = vClmb + 20;
            }
        }


    }
}
