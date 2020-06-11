package org.fol37.quinzainedulivre.importXls.importexcel;

import org.fol37.quinzainedulivre.repository.AgeRepository;
import org.fol37.quinzainedulivre.repository.CategorieRepository;
import org.fol37.quinzainedulivre.repository.EditeurRepository;
import org.fol37.quinzainedulivre.repository.LivreRepository;
import org.springframework.stereotype.Service;

import javax.inject.Inject;

@Service
public class Truncate {

    @Inject
    LivreRepository livreRepository;
    @Inject
    AgeRepository ageRepository;
    @Inject
    CategorieRepository categorieRepository;
    @Inject
    EditeurRepository editeurRepository;

    public void truncate() {
        livreRepository.deleteAll();
        categorieRepository.deleteAll();
        editeurRepository.deleteAll();
        ageRepository.deleteAll();
    }
}
