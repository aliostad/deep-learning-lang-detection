<?php

namespace Heystack\Core\Traits;

use Heystack\Core\DataObjectSchema\SchemaService;

/**
 * Allows a using class to set a schema service
 * @package Heystack\Core\Traits
 */
trait HasSchemaServiceTrait
{
    /**
     * @var \Heystack\Core\DataObjectSchema\SchemaService
     */
    protected $schemaService;

    /**
     * @param \Heystack\Core\DataObjectSchema\SchemaService $schemaService
     * @return void
     */
    public function setSchemaService(SchemaService $schemaService)
    {
        $this->schemaService = $schemaService;
    }

    /**
     * @return \Heystack\Core\DataObjectSchema\SchemaService
     */
    public function getSchemaService()
    {
        return $this->schemaService;
    }
} 