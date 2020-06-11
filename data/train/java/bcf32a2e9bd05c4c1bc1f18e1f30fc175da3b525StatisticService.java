package com.softserve.edu.service.admin;

import com.softserve.edu.repository.DeviceRepository;
import com.softserve.edu.repository.OrganizationRepository;
import com.softserve.edu.repository.UserRepository;
import com.softserve.edu.repository.VerificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class StatisticService {

    @Autowired
    private OrganizationRepository organizationRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private DeviceRepository deviceRepository;

    @Autowired
    private VerificationRepository verificationRepository;

    public Long countOrganizations() {
        return organizationRepository.count();
    }

    public Long countUsers() {
        return userRepository.count();
    }

    public Long countDevices() {
        return deviceRepository.count();
    }

    public Long countVerifications() {
        return verificationRepository.count();
    }
}
