<?php

/**
 * @file
 * Contains \Drupal\service_container_annotation_discovery\ServiceContainer\ServiceProvider\ServiceContainerAnnotationDiscoveryServiceProvider
 */

namespace Drupal\service_container_annotation_discovery\ServiceContainer\ServiceProvider;

use Drupal\service_container\ServiceContainer\ServiceProvider\ServiceContainerServiceProvider;

/**
 * Provides render cache service definitions.
 *
 * @codeCoverageIgnore
 *
 */
class ServiceContainerAnnotationDiscoveryServiceProvider extends ServiceContainerServiceProvider {

  /**
   * {@inheritdoc}
   */
  public function getContainerDefinition() {
    $services = array();
    $parameters['service_container.plugin_managers'] = array();
    $parameters['service_container.plugin_manager_types'] = array(
      'annotated' => '\Drupal\service_container_annotation_discovery\Plugin\Discovery\AnnotatedClassDiscovery',
    );

    return array(
      'parameters' => $parameters,
      'services' => $services,
    );
  }
}
