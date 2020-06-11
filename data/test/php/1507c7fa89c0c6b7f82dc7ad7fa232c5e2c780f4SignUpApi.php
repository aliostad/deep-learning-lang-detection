<?php

require_once '../service/SignUpService.php';

use service\SignUpService;

$service = new SignUpService();

$service->saveMember(null);
$service->saveAddress(null);
$service->savePaymentMethod(null);
$service->saveMailAddress(null);

$service->savePlan(null);

$service->payContractCharge(
    $service->findMember(null),
    $service->findPaymentMethod(null)
);

$service->payPlanFee(
    $service->findMember(null),
    $service->findPaymentMethod(null),
    $service->findPlan(null)
);

$service->sendMailAtContract(
    $service->findMember(null),
    $service->findMailAddress(null)
);

