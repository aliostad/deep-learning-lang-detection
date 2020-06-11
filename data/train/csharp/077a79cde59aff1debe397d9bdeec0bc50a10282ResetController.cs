using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MusicSchool.Models;
using System.Diagnostics;
using System.Data.Entity.Core.Objects;
namespace MusicSchool.Controllers
{
    public class ResetController : Controller
    {
        private MusicSchoolDbContext MusicSchoolDB = new MusicSchoolDbContext();
        /* Re creates the database and populates data */
        public ActionResult Index()
        {
            MusicSchoolDB.Database.Delete();// reset database
            MusicSchoolDB.Database.Create();
            PopulateInstruments();
            PopulateStudents();
            PopulateTutors();
            PopulateQualifications();
            return View();
        }
         /*************************************************************************************************************************************************************
                                                            POPULATING THE DATABASE
         * ***********************************************************************************************************************************************************
         */
        public Instrument findInstrument(int id)
        {
            return MusicSchoolDB.Instruments.Find(id);
        }
        
        /* Inserting Students */
        public void PopulateStudents()
        {
            List<Student> Students = new List<Student>
            {
                new Student{FirstName="Arthur", LastName="Miller", PhoneNumber=113456789, Age=14, Instrument = findInstrument(2), OwnInstrument = true},
                new Student{FirstName="Leonard", LastName="Cohen", PhoneNumber=223456789, Age=8, Instrument = findInstrument(3), OwnInstrument = true},
                new Student{FirstName="Maria", LastName="Callas", PhoneNumber=333456789, Age=4, Instrument = findInstrument(3), OwnInstrument = true},
                new Student{FirstName="Jessye", LastName="Norman", PhoneNumber=443456789, Age=16, Instrument = findInstrument(4), OwnInstrument = true},
                new Student{FirstName="Kathleen", LastName="Battle", PhoneNumber=553456789, Age=17, Instrument = findInstrument(6), OwnInstrument = false},
            };
            foreach(Student s in Students)
            {
                MusicSchoolDB.Students.Add(s);
            }
            MusicSchoolDB.SaveChanges();
        }

        /* Inserting Instruments */
        public void PopulateInstruments()
        {

            List<Instrument> Instruments = new List<Instrument>
            {
                new Instrument{Name="Cello", RentalFee=40},
                new Instrument{Name="Flute", RentalFee=25},
                new Instrument{Name="Violin", RentalFee=25},
                new Instrument{Name="Clarinet", RentalFee=40},
                new Instrument{Name="Trumpet", RentalFee=60},
                new Instrument{Name="Trombone", RentalFee=65},
                new Instrument{Name="Saxophone", RentalFee=60},
            };
            foreach (Instrument i in Instruments)
            {
                MusicSchoolDB.Instruments.Add(i);
            }
            MusicSchoolDB.SaveChanges();
        }

        /* Inserting Tutors */
        public void PopulateTutors()
        {
            List<Tutor> Tutors = new List<Tutor>
            {
                new Tutor{FirstName = "Craig", LastName = "Foss", PhoneNumber=123456789},
                new Tutor{FirstName = "Kevin", LastName = "Hague", PhoneNumber=223456789},
                new Tutor{FirstName = "Kris", LastName = "Faafoi", PhoneNumber=323456789},
                new Tutor{FirstName = "Nanaia", LastName = "Mahuta", PhoneNumber=423456789},
                new Tutor{FirstName = "Stuart", LastName = "Nash", PhoneNumber=523456789},
            };
            foreach (Tutor t in Tutors)
            {
                MusicSchoolDB.Tutors.Add(t);
            }
            MusicSchoolDB.SaveChanges();
        }

        /* Inserting Qualifications */
        public void PopulateQualifications()
        {
            List<InstrumentQualification> InstrumentQualifications = new List<InstrumentQualification>
            {
                new InstrumentQualification{ InstrumentID=1, Level=7,TutorID=1},
                new InstrumentQualification{ InstrumentID=2, Level=6,TutorID=1},
                new InstrumentQualification{ InstrumentID=3, Level=8,TutorID=1},
                new InstrumentQualification{ InstrumentID=2, Level=6,TutorID=2},
                new InstrumentQualification{ InstrumentID=4, Level=9,TutorID=2},
                new InstrumentQualification{ InstrumentID=5, Level=9,TutorID=3},
                new InstrumentQualification{ InstrumentID=6, Level=7,TutorID=3},
                new InstrumentQualification{ InstrumentID=4, Level=6,TutorID=3},
                new InstrumentQualification{ InstrumentID=3, Level=9,TutorID=4},
                new InstrumentQualification{ InstrumentID=1, Level=6,TutorID=4},
                new InstrumentQualification{ InstrumentID=2, Level=8,TutorID=5},
                new InstrumentQualification{ InstrumentID=7, Level=8,TutorID=5},
            };
            foreach (InstrumentQualification iq in InstrumentQualifications)
            {
                MusicSchoolDB.InstrumentQualifications.Add(iq);
            }
            
            MusicSchoolDB.SaveChanges();
        }
	}
}
	