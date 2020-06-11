namespace Squire.Security.Authorization
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using Squire.Decoupled.Queries;
    using Squire.Security.Authorization.Queries;
    using Squire.Validation;

    public static class DecoupledAuthorizationExtensions
    {
        public static ICollection<IRole> GetRolesForPlayer(this IDispatchQuery dispatch, IPlayer player)
        {
            dispatch.VerifyParam("dispatch").IsNotNull();
            return dispatch.Execute(new GetRolesForPlayer(player));
        }

        public static ICollection<IRole> GetAllRoles(this IDispatchQuery dispatch)
        {
            dispatch.VerifyParam("dispatch").IsNotNull();
            return dispatch.Execute(new GetAllRoles());
        }

        public static ICollection<IRole> GetRoles(this IDispatchQuery dispatch, int pageIndex, int pageSize, string nameFilter = null)
        {
            dispatch.VerifyParam("dispatch").IsNotNull();
            return dispatch.Execute(new GetRoles().WithNameLike(nameFilter).Page(pageIndex, pageSize));
        }
    }
}
