namespace StudentPractice.BusinessModel
{
    public partial class MassMessage
    {
        public enReporterType ReporterType
        {
            get { return (enReporterType)ReporterTypeInt; }
            set
            {
                if (ReporterTypeInt != (int)value)
                    ReporterTypeInt = (int)value;
            }
        }

        public enDispatchType DispatchType
        {
            get { return (enDispatchType)DispatchTypeInt; }
            set
            {
                if (DispatchTypeInt != (int)value)
                    DispatchTypeInt = (int)value;
            }
        }
    }
}
