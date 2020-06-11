package demo.service;

import demo.repository.DeveloperRepository;
import demo.repository.ProjectRepository;
import demo.repository.SpecialityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by FlayRonin on 06/07/2015.
 */
@Service
public class ReviewService {
    @Autowired
    private DeveloperRepository developerRepository;
    @Autowired
    private ProjectRepository projectRepository;
    @Autowired
    private SpecialityRepository specialityRepository;

    public void testReview(){

    }
}
