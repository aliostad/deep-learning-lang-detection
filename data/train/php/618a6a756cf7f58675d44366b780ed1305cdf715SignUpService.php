<?php

namespace service;

require_once '../repository/MemberRepository.php';
require_once '../repository/AddressRepository.php';
require_once '../repository/PaymentMethodRepository.php';
require_once '../repository/MailAddressRepository.php';
require_once '../repository/MailRepository.php';
require_once '../repository/PaymentRepository.php';
require_once '../repository/PlanRepository.php';

use repository\AddressRepository;
use repository\MailAddressRepository;
use repository\MailRepository;
use repository\MemberRepository;
use repository\PaymentMethodRepository;
use repository\PaymentRepository;
use repository\PlanRepository;

class SignUpService
{
    use MemberRepository;
    use AddressRepository;
    use PaymentMethodRepository;
    use MailAddressRepository;
    use MailRepository;
    use PlanRepository;
    use PaymentRepository;
}