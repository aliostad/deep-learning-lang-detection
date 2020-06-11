using Likkle.DataModel.Repositories;

namespace Likkle.DataModel.UnitOfWork
{
    public interface ILikkleUoW
    {
        AreaRepository AreaRepository { get; }
        GroupRepository GroupRepository { get; }
        TagRepository TagRepository { get; }
        UserRepository UserRepository { get; }
        LanguageRepository LanguageRepository { get; }
        NotificationSettingRepository NotificationSettingRepository { get; }
        HistoryGroupRepository HistoryGroupRepository { get; }

        void Save();
    }
}
