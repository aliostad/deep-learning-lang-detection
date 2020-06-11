using System;
using System.Threading.Tasks;
using Zazz.Core.Interfaces.Repositories;

namespace Zazz.Core.Interfaces
{
    public interface IUoW : IDisposable
    {
        ILinkedAccountRepository LinkedAccountRepository { get; }
        ICommentRepository CommentRepository { get; }
        IEventRepository EventRepository { get; }
        IFollowRepository FollowRepository { get; }
        IFollowRequestRepository FollowRequestRepository { get; }
        IAlbumRepository AlbumRepository { get; }
        IPhotoRepository PhotoRepository { get; }
        IUserRepository UserRepository { get; }
        IValidationTokenRepository ValidationTokenRepository { get; }
        IFacebookSyncRetryRepository FacebookSyncRetryRepository { get; }
        IFeedRepository FeedRepository { get; }
        IPostRepository PostRepository { get;}
        IFacebookPageRepository FacebookPageRepository { get; }
        IFeedPhotoRepository FeedPhotoRepository { get; }
        INotificationRepository NotificationRepository { get; }
        ICategoryStatRepository CategoryStatRepository { get; }
        IWeeklyRepository WeeklyRepository { get; }
        IPhotoLikeRepository PhotoLikeRepository { get; }
        IPostLikeRepository PostLikeRepository { get; }
        IUserReceivedLikesRepository UserReceivedLikesRepository { get; }
        IOAuthRefreshTokenRepository OAuthRefreshTokenRepository { get; }
        IClubPointRewardScenarioRepository ClubPointRewardScenarioRepository { get; }
        IClubRewardRepository ClubRewardRepository { get; }
        IUserRewardRepository UserRewardRepository { get; }
        IUserPointRepository UserPointRepository { get; }
        IUserPointHistoryRepository UserPointHistoryRepository { get; }
        IUserRewardHistoryRepository UserRewardHistoryRepository { get; }
        ITagRepository TagRepository { get; }
        ICityRepository CityRepository { get; }
        IMajorRepository MajorRepository { get; }
        ISchoolRepository SchoolRepository { get; }

        void SaveChanges();
    }
}