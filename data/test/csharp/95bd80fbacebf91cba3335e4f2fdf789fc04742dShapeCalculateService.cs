using CIDemo.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CIDemo.Services
{
    public class ShapeCalculateService
    {
        private IShapeCalculate _shapeCalculate;

        public ShapeCalculateService(IShapeCalculate shapeCalculate)
        {
            this._shapeCalculate = shapeCalculate;
        }

        public string PrintCalculateTotalSurface(double width, double height)
        {
            return $" {this._shapeCalculate.CalculateSurface(width, height)}";
        }
        
    }
}
