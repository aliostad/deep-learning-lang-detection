package org.gbif.portal.action.country;

import org.gbif.api.service.checklistbank.DatasetMetricsService;
import org.gbif.api.service.metrics.CubeService;
import org.gbif.api.service.occurrence.OccurrenceCountryIndexService;
import org.gbif.api.service.occurrence.OccurrenceDatasetIndexService;
import org.gbif.api.service.registry.DatasetSearchService;
import org.gbif.api.service.registry.DatasetService;
import org.gbif.api.service.registry.NodeService;
import org.gbif.api.service.registry.OrganizationService;

import com.google.inject.Inject;

public class PublicationsAction extends CountryBaseAction {

  @Inject
  public PublicationsAction(NodeService nodeService, CubeService cubeService,
    OccurrenceDatasetIndexService datasetIndexService, OccurrenceCountryIndexService countryIndexService,
    DatasetService datasetService, DatasetSearchService datasetSearchService,
    DatasetMetricsService datasetMetricsService, OrganizationService organizationService) {

    super(nodeService, cubeService, datasetIndexService, countryIndexService, datasetService, datasetSearchService,
      datasetMetricsService, organizationService);
  }

}
