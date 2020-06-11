using Csla;
using System;
using System.Collections.Generic;
using System.Linq;
using Bd.Icm.DataAccess;
using JetBrains.Annotations;

namespace Bd.Icm
{
    [Serializable]
    public class InstrumentCommitList : ReadOnlyBindingListBase<InstrumentCommitList, InstrumentCommitInfo>
    {
        #region [Factory Methods]

        public static InstrumentCommitList GetInstrumentCommitList(int instrumentId)
        {
            return
                DataPortal.Fetch<InstrumentCommitList>(instrumentId);
        }

        #endregion

        #region [Data Access]

        [UsedImplicitly]
        private void DataPortal_Fetch(int instrumentId)
        {
            using (var repository = RepositoryFactory.Instance.GetRepository<IInstrumentCommitRepository>())
            {
                var items = repository.FetchAll().Where(x => x.InstrumentId == instrumentId).OrderByDescending(x => x.CreatedDate);
                AddItems(items);
            }
        }

        private void AddItems(IEnumerable<DataAccess.Database.InstrumentCommit> items)
        {
            RaiseListChangedEvents = false;
            IsReadOnly = false;

            foreach (var item in items)
            {
                Add(InstrumentCommitInfo.GetInstrumentCommitInfo(item));
            }

            IsReadOnly = true;
            RaiseListChangedEvents = true;

        }
        #endregion
    }
}
