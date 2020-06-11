<?php

class KursyController extends Controller {
    public function __call($method, $arguments) {
        if(!empty($_SESSION['pracownik'])){
            $prac = unserialize($_SESSION['pracownik'])->getStanowisko();
        }
        else {
            $prac = 'niezalogowany';
        }
        if(method_exists($this, $method)) {
            $access = array();
            switch($prac){
                case 'kierownik':
                    $access[] = 'index';
                    $access[] = 'add';
                    $access[] = 'del';
                    $access[] = 'edit';
                    break;
                default:
                    $access[] = 'index';
                    break;
            };
            if($prac=='admin' || in_array($method, $access)){
                call_user_func_array(array($this,$method),$arguments);
            }
            else {
                $this->setFlash("Brak dostępu.");
                $this->redirect("/");
            }
        }
    }
    
    private function index(){
        $pojazdyFacade = new pojazdyFacade;
        $pojazdy = $pojazdyFacade->getPojazdy();
        $poj = array();
        foreach($pojazdy as $pojazd){
            $poj[$pojazd->getId()] = $pojazd;
        }
        $this->addVar('poj', $poj);
        $facade = new kursyFacade();
        $data = $facade->getKursy();
        $this->addVar('kursyData', $data);
        $this->render('index', 'kursy/');
    }
    
    private function add(){
        if(empty($_POST)){
            // Formularz nie został wysłany.
        }
        // TODO: walidacja danych
        else {
            $date = new DateTime($_POST['date'], new \DateTimeZone('Europe/Warsaw'));
            $czas = explode(":", $_POST['time']);
            $date->setTime($czas[0], $czas[1], 0);

            $kurs = new kursy();
            $kurs->setCreated();
            $kurs->setdataKursu($date);
            if($_POST['pojazd'] == 0){
                $kurs->setIdPojazdu(NULL);
            }
            else {
                $kurs->setIdPojazdu($_POST['pojazd']);            
            }
            $kurs->setIdTrasy($_POST['trasa']);
            $facade = new kursyFacade();
            $facade->addKurs($kurs);
            $this->setFlash("Kurs został dodany.");
        }
        
        $pojazdyFacade = new pojazdyFacade();
        $pojazdy = $pojazdyFacade->getPojazdy();
        $this->addVar("pojazdy", $pojazdy);
        
        $trasyFacade = new trasyFacade();
        $trasy = $trasyFacade->getTrasy();
        $this->addVar("trasy", $trasy);
        
        $this->render('add', 'kursy/');
    }
    
    private function del(){
        if(isset($_POST['del_submit'])){
            if(!empty($_GET['data']) && is_numeric($_GET['data']) ){
                $id = $_GET['data'];
            } else {
                $this->setFlash("Niepoprawne id.");
                $this->redirect("/");
            }
            
            $facade = new kursyFacade();
            $poj = $facade->getKursById($id);
            if(!empty($poj)){
                $facade->removeKurs($poj);
                $this->setFlash("Kurs został usunięty.");
            }     
            $this->redirect("/kursy");
        } else {
            $this->render("del", "kursy/");
        }
    }
    
    private function edit(){
        if(!empty($_GET['data']) && is_numeric($_GET['data']) ){
            $id = $_GET['data'];
        } else {
            $this->setFlash("Niepoprawne id.");
            $this->redirect("/");
        }
        
        $kursyFacade = new kursyFacade();
        $kurs = $kursyFacade->getKursById($id);
        if(empty($_POST)){
            // Formularz nie został wysłany.
        }
        // TODO: walidacja danych
        else {
            $date = new DateTime($_POST['date'], new \DateTimeZone('Europe/Warsaw'));
            $czas = explode(":", $_POST['time']);
            $date->setTime($czas[0], $czas[1], 0);
            
            $kurs->setCreated();
            $kurs->setdataKursu($date);
            if($_POST['pojazd'] == 0){
                $kurs->setIdPojazdu(NULL);
            }
            else {
                $kurs->setIdPojazdu($_POST['pojazd']);            
            }
            $kurs->setIdTrasy($_POST['trasa']);
            $kurs->setModified();
            $kursyFacade->updateKurs($kurs);
            $this->setFlash("Kurs został zaktualizowany.");
        }
        $this->addVar("data_kurs", $kurs);
        
        $pojazdyFacade = new pojazdyFacade();
        $pojazdy = $pojazdyFacade->getPojazdy();
        $this->addVar("pojazdy", $pojazdy);
        
        $trasyFacade = new trasyFacade();
        $trasy = $trasyFacade->getTrasy();
        $this->addVar("trasy", $trasy);
        
        $this->render('edit', 'kursy/');
    
    }
}

?>