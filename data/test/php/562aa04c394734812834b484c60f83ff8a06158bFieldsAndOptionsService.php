<?php

namespace WilliamEspindola\Field\Service;

use WilliamEspindola\Field\Repository\FieldRepository;
use WilliamEspindola\Field\Repository\OptionRepository;
use Respect\Relational\Sql;

class FieldsAndOptionsService 
{
    /**
     * @var Object WilliamEspindola\Field\Repository\FieldRepository
     */
    protected $fieldRepository;

    /**
     * @var Object WilliamEspindola\Field\Repository\OptionRepository
     */
    protected $optionRepository;

    public function __construct(
        FieldRepository $fieldRepository,
        OptionRepository $optionRepository
    ) {
        $this->fieldRepository = $fieldRepository;
        $this->optionRepository = $optionRepository;
    }

    public function findAllFieldsAnOptions()
    {
        $fields = $this->fieldRepository->findAll();

        foreach ($fields as $k => $field) {
            $fields[$k]['options'] = $this->optionRepository->findBy(
                ['field_id' => $field->getId()],
                Sql::orderBy('id')
            );
        }

        return $fields;
    }
} 