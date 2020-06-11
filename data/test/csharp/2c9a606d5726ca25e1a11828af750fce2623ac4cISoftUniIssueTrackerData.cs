using SIT.Data.Repositories;
using SIT.Models;

namespace SIT.Data.Interfaces
{
    public interface ISoftUniIssueTrackerData
    {
        UserRepository UserRepository { get; }
        EntityRepository<Project> ProjectRepository { get; }
        EntityRepository<ProjectLabel> ProjectLabelsRepository { get; }
        EntityRepository<ProjectPriority> ProjectPrioritiesRepository { get; }
        EntityRepository<Comment> CommentRepository { get; }
        EntityRepository<Issue> IssueRepository { get; }
        EntityRepository<IssueLabel> IssueLabelsRepository { get; }
        EntityRepository<Label> LabelRepository { get; }
        EntityRepository<Priority> PriorityRepository { get; }
        EntityRepository<Status> StatusRepository { get; }
        EntityRepository<StatusTransition> StatusTransitionRepository { get; }
        EntityRepository<TransitionScheme> TransitionSchemeRepository { get; }

        void Save();
        void Dispose();
    }
}
