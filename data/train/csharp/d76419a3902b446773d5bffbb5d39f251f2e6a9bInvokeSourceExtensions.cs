using BotBits.Commands;

namespace BotBits.Permissions
{
    public static class InvokeSourceExtensions
    {
        public static IPermissionInvokeSource ToPermissionInvokeSource(this IInvokeSource source)
        {
            var permissionSource = source as IPermissionInvokeSource;
            if (permissionSource != null) return permissionSource;

            var pSource = source as PlayerInvokeSource;
            if (pSource != null) return new PlayerPermissionInvokeSourceAdapter(pSource);

            throw new InvalidInvokeSourceCommandException(
                "Unable to retrieve your permissions. Command could not be run.");
        }

        public static Group GetGroup(this IInvokeSource source)
        {
            try
            {
                return source.ToPermissionInvokeSource().Group;
            }
            catch (InvalidInvokeSourceCommandException)
            {
                return Group.External;
            }
        }
    }
}