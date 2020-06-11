package service.impl;

import model.Company;
import model.Vacancy;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import repository.CompanyRepository;
import repository.VacancyRepository;
import service.CompanyService;

@Service
public class CompanyServiceImpl implements CompanyService {

    private CompanyRepository companyRepository;
    private VacancyRepository vacancyRepository;

    @Autowired
    public CompanyServiceImpl(CompanyRepository companyRepository, VacancyRepository vacancyRepository) {
        this.companyRepository = companyRepository;
        this.vacancyRepository = vacancyRepository;
    }

    @Override
    public Vacancy getVacancyById(Long id) {
        return vacancyRepository.findOne(id);
    }


    public Company getCompanyById (Long id){
        return companyRepository.findOne(id);
    }
}
