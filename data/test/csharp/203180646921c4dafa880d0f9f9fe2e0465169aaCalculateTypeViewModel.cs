using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MVVMCalc.Common;
using MVVMCalc.Model;

namespace MVVMCalc.ViewModel
{
    public class CalculateTypeViewModel : ViewModelBase
    {
        public CalculateType CalculateType { get; private set; }
        public string Label { get; private set; }

        public CalculateTypeViewModel(CalculateType calculateType, string label)
        {
            this.CalculateType = calculateType;
            this.Label = label;
        }

        private static Dictionary<CalculateType, string> typeLabelMap = new Dictionary<CalculateType, string>
        {
            {CalculateType.None, "未選択"},
            {CalculateType.Add, "足し算"},
            {CalculateType.Sub, "引き算"},
            {CalculateType.Mul, "掛け算"},
            {CalculateType.Div, "割り算"}
        };

        public static CalculateTypeViewModel Create(CalculateType type)
        {
            return new CalculateTypeViewModel(type, typeLabelMap[type]);
        }

        public static IEnumerable<CalculateTypeViewModel> Create()
        {
            foreach(CalculateType e in Enum.GetValues(typeof(CalculateType)))
            {
                yield return Create(e);
            }
        }
    }
}
