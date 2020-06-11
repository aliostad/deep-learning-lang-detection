package com.badun.hostel.service.data;

import com.badun.hostel.data.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.repository.NoRepositoryBean;
import org.springframework.stereotype.Service;

/**
 * Created by Artsiom Badun.
 */
@Service
@NoRepositoryBean
public class RepositoryLocator {

    @Autowired
    private HostelManagerRepository hostelManagerRepository;
    @Autowired
    private HostelRepository hostelRepository;
    @Autowired
    private RoleRepository roleRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private VisitorRepository visitorRepository;
    @Autowired
    private VisitRepository visitRepository;

    public HostelManagerRepository getHostelManagerRepository() {
        return hostelManagerRepository;
    }

    public HostelRepository getHostelRepository() {
        return hostelRepository;
    }

    public RoleRepository getRoleRepository() {
        return roleRepository;
    }

    public UserRepository getUserRepository() {
        return userRepository;
    }

    public VisitorRepository getVisitorRepository() {
        return visitorRepository;
    }

    public VisitRepository getVisitRepository() {
        return visitRepository;
    }
}
