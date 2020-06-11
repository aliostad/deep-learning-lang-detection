package org.hillel.it.votecollector.bootstrap;

import org.hillel.it.votecollector.model.entity.NetworkMemberSite;
import org.hillel.it.votecollector.repository.Impl.PersonRepositoryImpl;
import org.hillel.it.votecollector.repository.Impl.SiteRepositoryImpl;
import org.hillel.it.votecollector.repository.Impl.SubjectRepositoryImpl;
import org.hillel.it.votecollector.repository.Impl.VoteRepositoryImpl;
import org.hillel.it.votecollector.repository.PersonRepository;
import org.hillel.it.votecollector.repository.SiteRepository;
import org.hillel.it.votecollector.repository.SubjectRepository;
import org.hillel.it.votecollector.repository.VoteRepository;
import org.hillel.it.votecollector.service.VoteCollectorService;
import org.hillel.it.votecollector.service.VoteCollectorServiceImpl;

/**
 * Created with IntelliJ IDEA.
 * User: Vladislav Karpenko
 * Date: 23.11.13
 * Time: 1:36
 */
public class Starter {
    public static void main(String[] args) throws Exception {


        PersonRepository personRepository = new PersonRepositoryImpl();
        SiteRepository siteRepository = new SiteRepositoryImpl();
        VoteRepository voteRepository = new VoteRepositoryImpl();
        SubjectRepository subjectRepository = new SubjectRepositoryImpl();
        VoteCollectorService service = new VoteCollectorServiceImpl(personRepository, siteRepository, voteRepository, subjectRepository);
        siteRepository.saveSite(new NetworkMemberSite());

        personRepository.shutDown();
        siteRepository.shutDown();
        voteRepository.shutDown();
        subjectRepository.shutDown();
        System.out.println(siteRepository.countSites());

    }
}