package com.gdiama.app;

import com.gdiama.infrastructure.AppointmentRepository;
import com.gdiama.infrastructure.AppointmentRequestRepository;
import com.gdiama.infrastructure.AuditRepository;

public class AppointmentMakerFactory {
    private final AppointmentRepository appointmentRepository;
    private final AuditRepository auditRepository;
    private AppointmentRequestRepository appointmentRequestRepository;

    public AppointmentMakerFactory(AppointmentRepository appointmentRepository, AuditRepository auditRepository, AppointmentRequestRepository appointmentRequestRepository) {
        this.appointmentRepository = appointmentRepository;
        this.auditRepository = auditRepository;
        this.appointmentRequestRepository = appointmentRequestRepository;
    }

    public AppointmentMaker newAppointmentMaker() throws Exception {
        return new AppointmentMaker(appointmentRepository, auditRepository, appointmentRequestRepository);
    }
}
