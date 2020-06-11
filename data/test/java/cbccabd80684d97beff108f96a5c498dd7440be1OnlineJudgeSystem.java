package com.firefrydev.ojh.core;

public class OnlineJudgeSystem {
    private final ProblemService problemService;
    private final VerificationService verificationService;

    public OnlineJudgeSystem(ProblemService problemService, VerificationService verificationService) {
        this.problemService = problemService;
        this.verificationService = verificationService;
    }

    public ProblemService getProblemService() {
        return problemService;
    }

    public VerificationService getVerificationService() {
        return verificationService;
    }
}
