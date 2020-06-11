using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BusinessLogic.Interfaces;

namespace BusinessLogic
{
   public class DataManager
   {//в этом классе ценрализовано происходит обмен данными
       //этот класс будем внедрять в конструктор каждого контроллера
       private IPricesRepository pricesRepository;
       private IAdresRepository adresRepository;
       private IContaktnoeLicoRepository contaktnoeLicoRepository;
       private IClientsRepository clientsRepository;
       private IDogovorRepository dogovoraRepository;
       private IZakazyRepository zakazyRepository;
       private IZakazyAdresyRepository zakazyAdresyRepository;
       private IUsersRepository usersRepository;
       private IRazrabotkiRepository razrabotkiRepository;
       public DataManager(IPricesRepository pricesRepository, IAdresRepository adresRepository, IContaktnoeLicoRepository contaktnoeLicoRepository, IClientsRepository clientsRepository, IDogovorRepository dogovoraRepository, IZakazyRepository zakazyRepository, IZakazyAdresyRepository zakazyAdresyRepository, IUsersRepository usersRepository, IRazrabotkiRepository razrabotkiRepository)
       {
           this.pricesRepository = pricesRepository;
           this.adresRepository = adresRepository;
           this.clientsRepository = clientsRepository;
           this.contaktnoeLicoRepository = contaktnoeLicoRepository;
           this.dogovoraRepository = dogovoraRepository;
           this.zakazyRepository = zakazyRepository;
           this.zakazyAdresyRepository = zakazyAdresyRepository;
           this.usersRepository = usersRepository;
           this.razrabotkiRepository = razrabotkiRepository;
       }

      

       //объявим свойства через которые будем возвращать репозитории требуемые для работы
       
       public IPricesRepository PricesRepository
       {
           get { return pricesRepository;}
       }
       public IAdresRepository AdresRepository
       {
           get { return adresRepository; }
       }

       public IContaktnoeLicoRepository ContaktnoeLicoRepository
       {
           get { return contaktnoeLicoRepository; }
       }

       public IClientsRepository ClientsRepository
       {
           get { return clientsRepository; }
       }
       public IDogovorRepository DogovorRepository
       {
           get { return dogovoraRepository; }
       }
       public IZakazyRepository ZakazyRepository
       {
           get { return zakazyRepository; }
       }

       public IZakazyAdresyRepository ZakazyAdresyRepository
       {
           get { return zakazyAdresyRepository; }
       }

       public IUsersRepository UsersRepository
       {
           get { return usersRepository; }
       }

      public IRazrabotkiRepository RazrabotkiRepository
       {
           get { return razrabotkiRepository; }
       }
   }
}
