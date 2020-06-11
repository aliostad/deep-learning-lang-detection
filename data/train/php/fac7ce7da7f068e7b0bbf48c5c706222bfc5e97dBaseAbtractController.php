<?php

namespace AccountHon\Http\Controllers;

use AccountHon\Repositories\AccountingPeriodRepository;
use AccountHon\Repositories\AuxiliaryReceiptRepository;
use AccountHon\Repositories\AuxiliarySeatRepository;
use AccountHon\Repositories\BalancePeriodRepository;
use AccountHon\Repositories\CatalogRepository;

use AccountHon\Repositories\CostRepository;
use AccountHon\Repositories\FinancialRecordsRepository;
use AccountHon\Repositories\SeatingPartRepository;
use AccountHon\Repositories\SeatingRepository;
use AccountHon\Repositories\StudentRepository;
use AccountHon\Repositories\TempAuxiliarySeatRepository;
use AccountHon\Repositories\TypeFormRepository;
use AccountHon\Repositories\TypeSeatRepository;
use AccountHon\Repositories\ReceiptRepository;
use Illuminate\Http\Request;

use AccountHon\Http\Requests;
use AccountHon\Http\Controllers\Controller;

abstract class BaseAbtractController extends Controller
{
    /**
     * @var AccountingPeriodRepository
     */
    protected $accountingPeriodRepository;
    /**
     * @var AuxiliarySeatRepository
     */
    protected $auxiliarySeatRepository;
    /**
     * @var AuxiliaryReceiptRepository
     */
    protected $auxiliaryReceiptRepository;
    /**
     * @var SeatingRepository
     */
    protected $seatingRepository;

    /**
     * @var CatalogRepository
     */
    protected $catalogRepository;
    /**
     * @var BalancePeriodRepository
     */
    protected $balancePeriodRepository;
    /**
     * @var TypeFormRepository
     */
    protected $typeFormRepository;
    /**
     * @var CostRepository
     */
    protected $costRepository;
    /**
     * @var StudentRepository
     */
    protected $studentRepository;
    /**
     * @var FinancialRecordsRepository
     */
    protected $financialRecordsRepository;
    /**
     * @var TempAuxiliarySeatController
     */
    protected $tempAuxiliarySeatController;
    /**
     * @var TempAuxiliarySeatRepository
     */
    protected $tempAuxiliarySeatRepository;
    /**
     * @var AuxiliarySeatController
     */
    protected $auxiliarySeatController;
    /**
     * @var TypeSeatRepository
     */
    protected $typeSeatRepository;
    /**
     * @var SeatingPartRepository
     */
    protected $seatingPartRepository;


    /**
     * @param AccountingPeriodRepository $accountingPeriodRepository
     * @param AuxiliarySeatRepository $auxiliarySeatRepository
     * @param AuxiliaryReceiptRepository $auxiliaryReceiptRepository
     * @param SeatingRepository $seatingRepository
     * @param CatalogRepository $catalogRepository
     * @param BalancePeriodRepository $balancePeriodRepository
     * @param TypeFormRepository $typeFormRepository
     * @param CostRepository $costRepository
     * @param StudentRepository $studentRepository
     * @param FinancialRecordsRepository $financialRecordsRepository
     * @param TempAuxiliarySeatController $tempAuxiliarySeatController
     * @param TempAuxiliarySeatRepository $tempAuxiliarySeatRepository
     * @param AuxiliarySeatController $auxiliarySeatController
     * @internal param PeriodsRepository $periodsRepository
     */
    public function __construct(
        AccountingPeriodRepository $accountingPeriodRepository,
    AuxiliarySeatRepository $auxiliarySeatRepository,
    AuxiliaryReceiptRepository $auxiliaryReceiptRepository,
    SeatingRepository $seatingRepository,
    CatalogRepository $catalogRepository,
    BalancePeriodRepository $balancePeriodRepository,
    TypeFormRepository $typeFormRepository,
    CostRepository $costRepository,
    StudentRepository $studentRepository,
    FinancialRecordsRepository $financialRecordsRepository,
    TempAuxiliarySeatController $tempAuxiliarySeatController,
    TempAuxiliarySeatRepository $tempAuxiliarySeatRepository,
    AuxiliarySeatController $auxiliarySeatController,
    TypeSeatRepository $typeSeatRepository,
    SeatingPartRepository $seatingPartRepository,
    ReceiptRepository $receiptRepository

    ){

        $this->accountingPeriodRepository = $accountingPeriodRepository;
        $this->auxiliarySeatRepository = $auxiliarySeatRepository;
        $this->auxiliaryReceiptRepository = $auxiliaryReceiptRepository;
        $this->receiptRepository = $receiptRepository;
        $this->seatingRepository = $seatingRepository;
        $this->catalogRepository = $catalogRepository;
        $this->balancePeriodRepository = $balancePeriodRepository;
        $this->typeFormRepository = $typeFormRepository;
        $this->costRepository = $costRepository;
        $this->studentRepository = $studentRepository;
        $this->financialRecordsRepository = $financialRecordsRepository;
        $this->tempAuxiliarySeatController = $tempAuxiliarySeatController;
        $this->tempAuxiliarySeatRepository = $tempAuxiliarySeatRepository;
        $this->auxiliarySeatController = $auxiliarySeatController;
        $this->typeSeatRepository = $typeSeatRepository;
        $this->seatingPartRepository = $seatingPartRepository;

    }
}
