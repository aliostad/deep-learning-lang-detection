package repository;

public class Repository {

    //Clase que va a instanciar a todos los repositorios y se busca poder modificarlos.
    
    public ElectionRepository electionRepository = new ElectionRepository();
    public HabitantRepository habitantRepository = new HabitantRepository();
    public PoliticalPartyRepository politicalPartyRepository = new PoliticalPartyRepository();
    public ProvinceRepository provinceRepository = new ProvinceRepository();
    
    public Repository() {
        
    }
    
}
