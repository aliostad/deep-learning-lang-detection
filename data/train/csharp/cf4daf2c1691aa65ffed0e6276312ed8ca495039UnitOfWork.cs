using CodeAndPlay.Data.Contracts;
using CodeAndPlay.Data.Repositories.Generic;
using CodeAndPlay.Model.Context;
using CodeAndPlay.Model.Entities;
using System;

namespace CodeAndPlay.Data
{
    public class UnitOfWork : IUnitOfWork
    {
        #region Attributes
        private bool disposed;
        private SymposiumContext context;
        private IEntityRepository<Attendance> attendanceRepository;
        private IEntityRepository<Event> eventRepository;
        private IEntityRepository<Organizer> organizerRepository;
        private IEntityRepository<Requirement> requirementRepository;
        private IEntityRepository<Role> roleRepository;
        private IEntityRepository<Rule> ruleRepository;
        private IEntityRepository<School> schoolRepository;
        private IEntityRepository<Sponsor> sponsorRepository;
        private IEntityRepository<Student> studentRepository;
        private IEntityRepository<Talk> talkRepository;
        private IEntityRepository<TeamMember> teamMemberRepository;
        private IEntityRepository<Team> teamRepository;
        private IEntityRepository<Ticket> ticketRepository;
        private IEntityRepository<Workshop> workshopRepository;
        #endregion

        #region Repositories
        public IEntityRepository<Attendance> AttendanceRepository
        {
            get { return attendanceRepository ?? (attendanceRepository = new GenericRepository<SymposiumContext, Attendance>(context)); }
        }

        public IEntityRepository<Event> EventRepository
        {
            get { return eventRepository ?? (eventRepository = new GenericRepository<SymposiumContext, Event>(context)); }
        }

        public IEntityRepository<Organizer> OrganizerRepository
        {
            get { return organizerRepository ?? (organizerRepository = new GenericRepository<SymposiumContext, Organizer>(context)); }
        }

        public IEntityRepository<Requirement> RequirementRepository
        {
            get { return requirementRepository ?? (requirementRepository = new GenericRepository<SymposiumContext, Requirement>(context)); }
        }

        public IEntityRepository<Role> RoleRepository
        {
            get { return roleRepository ?? (roleRepository = new GenericRepository<SymposiumContext, Role>(context)); }
        }

        public IEntityRepository<Rule> RuleRepository
        {
            get { return ruleRepository ?? (ruleRepository = new GenericRepository<SymposiumContext, Rule>(context)); }
        }

        public IEntityRepository<School> SchoolRepository
        {
            get { return schoolRepository ?? (schoolRepository = new GenericRepository<SymposiumContext, School>(context)); }
        }

        public IEntityRepository<Sponsor> SponsorRepository
        {
            get { return sponsorRepository ?? (sponsorRepository = new GenericRepository<SymposiumContext, Sponsor>(context)); }
        }

        public IEntityRepository<Student> StudentRepository
        {
            get { return studentRepository ?? (studentRepository = new GenericRepository<SymposiumContext, Student>(context)); }
        }

        public IEntityRepository<Talk> TalkRepository
        {
            get { return talkRepository ?? (talkRepository = new GenericRepository<SymposiumContext, Talk>(context)); }
        }

        public IEntityRepository<TeamMember> TeamMemberRepository
        {
            get { return teamMemberRepository ?? (teamMemberRepository = new GenericRepository<SymposiumContext, TeamMember>(context)); }
        }

        public IEntityRepository<Team> TeamRepository
        {
            get { return teamRepository ?? (teamRepository = new GenericRepository<SymposiumContext, Team>(context)); }
        }

        public IEntityRepository<Ticket> TicketRepository
        {
            get { return ticketRepository ?? (ticketRepository = new GenericRepository<SymposiumContext, Ticket>(context)); }
        }

        public IEntityRepository<Workshop> WorkshopRepository
        {
            get { return workshopRepository ?? (workshopRepository = new GenericRepository<SymposiumContext, Workshop>(context)); }
        }
        #endregion

        public UnitOfWork(SymposiumContext context)
        {
            this.context = context;
        }

        public int Save()
        {
            int changes = 0;

            if (!disposed && context.ChangeTracker.HasChanges())
            {
                changes = context.SaveChanges();
            }

            return changes;
        }

        public void Dispose()
        {
            if (!disposed)
            {
                context.Dispose();
                GC.SuppressFinalize(this);
                disposed = true;
            }
        }
    }
}