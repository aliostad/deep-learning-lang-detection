using CrimeService.Model.Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CrimeService
{
    interface IUnitOfWork:IDisposable
    {
        void Commit();
        ClientRepository ClientRepository { get; }
        CrimeRepository CrimeRepository { get; }
        DistrictRepository DistrictRepository { get; }
        KindRepository KindRepository { get; }
        ParticipantRepository ParticipantRepository { get; }
        PersonRepository PersonRepository { get; }
        PlaceRepository PlaceRepository { get; }
        PunishmentRepository PunishmentRepository { get; }
        StateRepository StateRepository { get; }
        StatusRepository StatusRepository { get; }
    }
}
