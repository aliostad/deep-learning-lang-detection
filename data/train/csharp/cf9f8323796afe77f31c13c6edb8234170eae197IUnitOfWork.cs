using System;
using MyCommunity.DataAccess.Repositories;

namespace MyCommunity.DataAccess
{
    public interface IUnitOfWork:IDisposable
    {
        UsersRepository UsersRepository { get; }

        CommunityRepository CommunitiesRepository { get; }
        GroupsRepository GroupsRepository { get; }
        CampaignsRepository CampaignsRepository { get; }
        EventsRepository EventsRepository { get; }
        UserMessageRepository UserMessageRepository { get; }
        MessagesRepository MessagesRepository { get; }
        void Save();
    }
}