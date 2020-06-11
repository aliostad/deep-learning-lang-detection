#include "access.hh"
#include "db.hh"

namespace scissy
{
  bool accessCheckRepo(const Session & session,
                       uint64_t        repo_id,
                       pb::Role        role)
  {
    bool is_public;
    if (!Db::repoIsPublic(repo_id, &is_public))
      return false;

    if (is_public && role == pb::kReader)
      return true;

    if (session.userId() < 1)
      return false;

    pb::Role user_role = pb::kNone;
    if (!Db::repoGetUserRole(repo_id, session.userId(), &role))
      return false;

    return user_role >= role;
  }
}
