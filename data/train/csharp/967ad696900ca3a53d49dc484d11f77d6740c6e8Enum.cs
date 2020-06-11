namespace WarehouseEntry.Business.Define
{
    public enum SystemFunction
    {
        HomeControllerIndex,
        HomeControllerNoAccess,

        UserControllerUserIndex,
        UserControllerCreateRole,
        UserControllerDeleteRole,
        UserControllerCreateUser,
        UserControllerEnableUser,
        UserControllerChangePassword,

        UserControllerRightIndex,
        UserControllerEnableRight,

        EntryControllerEntryIndex,
        EntryControllerCreateEntry,
        EntryControllerEditEntry,
        EntryControllerCompleteEntry,
        EntryControllerBatchCreateEntry,
        EntryControllerBatchEditEntry,
        EntryControllerBatchCompleteEntry
    }
}