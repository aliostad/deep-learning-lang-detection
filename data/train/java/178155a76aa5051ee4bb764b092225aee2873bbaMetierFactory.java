/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Metier;

public class MetierFactory {

    private static LivreService livreService;
    private static BibliothecaireService bibliothecaireService;
    private static FileService fileService;
    private static CategorieService categorieService;
    private static Principale principale;
    private static ArmoireService armoireService;
    private static EtagereService etagereService;
    private static StructureBibliothequeService structureService;

    public static StructureBibliothequeService getStructureService() {
        if(structureService == null){
            structureService = new StructureBibliothequeServiceImpl();
        }
        return structureService;
    }

    public static EtagereService getEtagereService() {
        if(etagereService == null){
            etagereService = new EtagereServiceImpl();
        }
        return etagereService;
    }

    public static ArmoireService getArmoireService() {
        if(armoireService == null){
            armoireService = new ArmoireServiceImpl();
        }
        return armoireService;
    }

    public static CategorieService getCategorieService() {
        if (categorieService == null) {
            categorieService = new CategorieServiceImpl();
        }
        return categorieService;
    }
    
    public static Principale getPrincipale() {
        if (principale == null) {
            principale = new Principale();
        }
        return principale;
    }

    public static FileService getFileService() {
        if (fileService == null) {
            fileService = new FileServiceImpl();
        }
        return fileService;
    }

    public static LivreService getLivreService() {
        if (livreService == null) {
            livreService = new LivreServiceImpl();
        }
        return livreService;
    }

    public static BibliothecaireService getBibliothecaireService() {
        if (bibliothecaireService == null) {
            bibliothecaireService = new BibliothecaireServiceImpl();
        }
        return bibliothecaireService;
    }
}
