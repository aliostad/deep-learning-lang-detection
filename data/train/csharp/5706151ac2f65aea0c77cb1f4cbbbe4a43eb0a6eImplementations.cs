using Wags.DataModel;

namespace Wags.DataAccess
{
    public class PlayerRepository : GenericDataRepository<Player>, IPlayerRepository
    {
    }

    public class CourseRepository : GenericDataRepository<Course>, ICourseRepository
    {
    }

    public class MemberRepository : GenericDataRepository<Member>, IMemberRepository
    {
    }

    public class CourseDataRepository : GenericDataRepository<CourseData>, ICourseDataRepository
    {
    }

    public class EventRepository : GenericDataRepository<Event>, IEventRepository
    {
    }

    public class TrophyRepository : GenericDataRepository<Trophy>, ITrophyRepository
    {
    }

    public class BookingRepository : GenericDataRepository<Booking>, IBookingRepository
    {
    }

    public class GuestRepository : GenericDataRepository<Guest>, IGuestRepository
    {
    }

    public class HistoryRepository : GenericDataRepository<History>, IHistoryRepository
    {
    }

    public class TransactionRepository : GenericDataRepository<Transaction>, ITransactionRepository
    {
    }

    public class ScoreRepository : GenericDataRepository<Score>, IScoreRepository
    {
    }

    public class ClubRepository : GenericDataRepository<Club>, IClubRepository
    {
    }

    public class RoundRepository : GenericDataRepository<Round>, IRoundRepository
    {
    }
}
