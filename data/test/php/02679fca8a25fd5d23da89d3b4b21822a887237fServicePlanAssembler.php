<?php
/**
 * Created by PhpStorm.
 * User: faustos
 * Date: 03.03.14
 * Time: 17:45
 */

namespace Tixi\ApiBundle\Interfaces;


use Tixi\ApiBundle\Helper\DateTimeService;
use Tixi\CoreDomain\ServicePlan;

/**
 * Class ServicePlanAssembler
 * @package Tixi\ApiBundle\Interfaces
 */
class ServicePlanAssembler {
    /**
     * injected by service container via setter method
     * @var $dateTimeService DateTimeService
     */
    private $dateTimeService;

    /**
     * @param ServicePlanRegisterDTO $servicePlanDTO
     * @return ServicePlan
     */
    public function registerDTOtoNewServicePlan(ServicePlanRegisterDTO $servicePlanDTO) {
        $servicePlan = ServicePlan::registerServicePlan(
            $servicePlanDTO->start,
            $servicePlanDTO->end,
            $servicePlanDTO->subject,
            $servicePlanDTO->memo
        );
        return $servicePlan;
    }

    /**
     * @param ServicePlanRegisterDTO $servicePlanDTO
     * @param ServicePlan $servicePlan
     * @return ServicePlan
     */
    public function registerDTOtoServicePlan(ServicePlanRegisterDTO $servicePlanDTO, ServicePlan $servicePlan) {
        $servicePlan->updateServicePlanData(
            $servicePlanDTO->start,
            $servicePlanDTO->end,
            $servicePlanDTO->subject,
            $servicePlanDTO->memo
        );
        return $servicePlan;
    }

    /**
     * @param ServicePlan $servicePlan
     * @return ServicePlanRegisterDTO
     */
    public function toServicePlanRegisterDTO(ServicePlan $servicePlan) {
        $servicePlanDTO = new ServicePlanRegisterDTO();
        $servicePlanDTO->id = $servicePlan->getId();
        $servicePlanDTO->start =
            $this->dateTimeService->convertToLocalDateTime($servicePlan->getStart());
        $servicePlanDTO->end =
            $this->dateTimeService->convertToLocalDateTime($servicePlan->getEnd());
        $servicePlanDTO->subject = $servicePlan->getSubject();
        $servicePlanDTO->memo = $servicePlan->getMemo();
        return $servicePlanDTO;
    }

    /**
     * @param $servicePlans
     * @return array
     */
    public function servicePlansToServicePlanEmbeddedListDTOs($servicePlans) {
        $dtoArray = array();
        foreach ($servicePlans as $servicePlan) {
            $dtoArray[] = $this->toServicePlanEmbeddedListDTO($servicePlan);
        }
        return $dtoArray;
    }

    /**
     * @param ServicePlan $servicePlan
     * @return ServicePlanEmbeddedListDTO
     */
    public function toServicePlanEmbeddedListDTO(ServicePlan $servicePlan) {
        $servicePlanEmbeddedListDTO = new ServicePlanEmbeddedListDTO();
        $servicePlanEmbeddedListDTO->id = $servicePlan->getId();
        $servicePlanEmbeddedListDTO->vehicleId = $servicePlan->getVehicle()->getId();
        $servicePlanEmbeddedListDTO->subject = $servicePlan->getSubject();
        $servicePlanEmbeddedListDTO->start =
            $this->dateTimeService->convertToLocalDateTimeString($servicePlan->getStart());
        $servicePlanEmbeddedListDTO->end =
            $this->dateTimeService->convertToLocalDateTimeString($servicePlan->getEnd());
        return $servicePlanEmbeddedListDTO;
    }

    /**
     * @param $dateTimeService
     * Injected by service container
     */
    public function setDateTimeService(DateTimeService $dateTimeService) {
        $this->dateTimeService = $dateTimeService;
    }

}