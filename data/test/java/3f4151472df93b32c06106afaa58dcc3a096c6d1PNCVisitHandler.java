package org.smartregister.service.formsubmissionhandler;

import org.smartregister.domain.form.FormSubmission;
import org.smartregister.service.ChildService;
import org.smartregister.service.MotherService;

public class PNCVisitHandler implements FormSubmissionHandler {
    private final MotherService motherService;
    private ChildService childService;

    public PNCVisitHandler(MotherService motherService, ChildService childService) {
        this.motherService = motherService;
        this.childService = childService;
    }

    @Override
    public void handle(FormSubmission submission) {
        motherService.pncVisitHappened(submission);
        childService.pncVisitHappened(submission);
    }
}
