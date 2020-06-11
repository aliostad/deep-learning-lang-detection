using System;
using DAL.Data.Generic;
using DAL.Fake.Repo.Repository;
using Model;

namespace DAL.Data.UnitofWork
{
    public interface IUnitofWork : IDisposable
    {
        #region Model

        //Model
        IGenericRepository<Agenda> AgendaRepository { get; }
        IGenericRepository<Booths> BoothRepository { get; }
        IGenericRepository<Buyers> BuyerRepository { get; }
        IGenericRepository<Companies> CompanyRepository { get; }
        IGenericRepository<EventRateSection> EventRateSectionRepository { get; }
        IGenericRepository<Events> EventRepository { get; }
        IGenericRepository<EventTypes> EventTypeRepository { get; }
        IGenericRepository<FeedBacks> FeedBackRepository { get; }
        IGenericRepository<InvitationsAccepted> InvitationAcceptedRepository { get; }
        IGenericRepository<InvitationsRefuseds> InvitationRefusedRepository { get; }
        IGenericRepository<InvitationSchedules> InvitationScheduleRepository { get; }
        IGenericRepository<Invitations> InvitationsRepository { get; }
        IGenericRepository<Sellers> SellerRepository { get; }
        IGenericRepository<Speakers> SpeakerRepository { get; }
        IGenericRepository<SpeakerSchedules> SpeakerScheduleRepository { get; }
        IGenericRepository<Users> UserRepository { get; }
        IGenericRepository<UserTypes> UserTypeRepository { get; }


        #endregion

        #region Save

        void Save();

        #endregion
    }
}
