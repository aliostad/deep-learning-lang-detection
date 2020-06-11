using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace amis.Models
{
    public class CommonEnums
    {
        public enum DeletedRecordStates
        {
            NotDeleted = 0,
            DeletedOk = 1,
            NotFound = 3
        }

        public enum DispatchDocumentState
        {
            Draft = 0,
            Sent = 1,
            Aborted = 2
        }

        public static DispatchDocumentState GetDispatchDocumentState(int state)
        {
            if (state == 0) return DispatchDocumentState.Draft;
            if (state == 1) return DispatchDocumentState.Sent;
            if (state == 2) return DispatchDocumentState.Aborted;
            return DispatchDocumentState.Draft;
        }

        public enum PageActionEnum
        {
            Create = 1,
            Read = 2,
            Update = 3,
            Delete = 4,
            Find = 5,
            Execute = 6,
            Change = 7,
            Authorize = 8,
            GenerateReport = 9,
            LogIn =10,
            LogOut=11,
            Action1 = 12,
            Action2 = 13,
            Action3 = 14,
            Action4 = 15,
            Action5 = 16,
            Action6 = 17,
            Action7 = 18
        }

        public static int GetIntDispatchDocumentState(DispatchDocumentState state)
        {
            if (state == DispatchDocumentState.Draft) return 0;
            if (state == DispatchDocumentState.Sent) return 1;
            if (state == DispatchDocumentState.Aborted) return 2;
            return 0;
        }

        public static string GetStringDispatchDocumentState(DispatchDocumentState state)
        {
            if (state == DispatchDocumentState.Draft) return "0";
            if (state == DispatchDocumentState.Sent) return "1";
            if (state == DispatchDocumentState.Aborted) return "2";
            return "0";
        }

        public static string GetDispatchDocumentStateName(DispatchDocumentState state)
        {
            if (state == DispatchDocumentState.Draft) return "Borrador";
            if (state == DispatchDocumentState.Sent) return "Enviado";
            if (state == DispatchDocumentState.Aborted) return "Anulado";
            return "Borrador";
        }

        public static string GetDispatchDocumentStateName(int state)
        {
            if (state == 1) return "Borrador";
            if (state == 2) return "Enviado";
            if (state == 3) return "Anulado";
            return "Borrador";
        }

        public enum AmisUserTaskDoneState
        {
            Done = 1,
            NotDone = 2,
            Both = 3
        }
    }
}
