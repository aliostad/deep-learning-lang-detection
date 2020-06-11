using GalaSoft.MvvmLight.Messaging;
using MvvmLight2.ViewModel;

namespace MvvmLight2.Model
{
    public partial class TeachingLoad 
    {
        partial void OnLectureChanged()
        {
            TeachingLoad load = this;
            if (load != null)
            {
                SetTotalDisciplineLoad(load);
                //load.FlagChange = "*";
                Messenger.Default.Send<TeachingLoad, LoadChairViewModel>(this);
            }
        }

        partial void OnLaboratoryWorkChanged()
        {
            TeachingLoad load = this;
            if (load != null)
            {
                SetTotalDisciplineLoad(load);
                //load.FlagChange = "*";
                Messenger.Default.Send<TeachingLoad, LoadChairViewModel>(this);
            }
        }

        partial void OnPracticalExercisesChanged()
        {
            TeachingLoad load = this;
            if (load != null)
            {
                SetTotalDisciplineLoad(load);
                //load.FlagChange = "*";
                Messenger.Default.Send<TeachingLoad, LoadChairViewModel>(this);
            }
        }


        partial void OnStreamChanged()
        {
            //this.FlagChange = "*";
            Messenger.Default.Send<TeachingLoad, LoadChairViewModel>(this);
        }




        //partial void OnStreamLabChanged()
        //{
        //    this.FlagChange = "*";
        //    Messenger.Default.Send<TeachingLoad, LoadChairViewModel>(this);
        //}

        //partial void OnStreamPractChanged()
        //{
        //    this.FlagChange = "*";
        //    Messenger.Default.Send<TeachingLoad, LoadChairViewModel>(this);
        //}
       
        /// <summary>
        /// Вычисление суммарной нагрузки по дисциплине
        /// </summary>
        /// <param name="teach"></param>
        private static void SetTotalDisciplineLoad(TeachingLoad load)
        {
            load.SumLoad = 0;

            if (load.Lecture != null)
                load.SumLoad += load.Lecture;
            if (load.Consultation != null)
                load.SumLoad += load.Consultation;
            if (load.ControlWork != null)
                load.SumLoad += load.ControlWork;
            if (load.CourseProject != null) 
                load.SumLoad += load.CourseProject;
            if (load.CourseWorkt != null) 
                load.SumLoad += load.CourseWorkt;
            if (load.LaboratoryWork != null) 
                load.SumLoad += load.LaboratoryWork;
            if (load.PracticalExercises != null) 
                load.SumLoad += load.PracticalExercises;
            if (load.Examination != null) 
                load.SumLoad += load.Examination;
            if (load.SetOff != null) 
                load.SumLoad += load.SetOff;
            if (load.Gac != null) 
                load.SumLoad += load.Gac;
            if (load.GraduationDesign != null) 
                load.SumLoad += load.GraduationDesign;
            if (load.Others != null) 
                load.SumLoad += load.Others;
            if (load.Practical != null) 
                load.SumLoad += load.Practical;
            if (load.Dot != null) 
                load.SumLoad += load.Dot;
            if (load.ScientificResearchWork != null)
                load.SumLoad += load.ScientificResearchWork;


            load.SumUnload = load.SumLoad;
            if ((load.CommerceStudent != null) && (load.Student != 0))
                load.SumCommerce = load.SumLoad * (decimal)load.CommerceStudent / (decimal)load.Student;
        }
    }
}
