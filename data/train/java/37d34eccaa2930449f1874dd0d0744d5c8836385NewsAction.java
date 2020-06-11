package org.gbif.portal.action.country;

import org.gbif.api.service.checklistbank.DatasetMetricsService;
import org.gbif.api.service.metrics.CubeService;
import org.gbif.api.service.occurrence.OccurrenceCountryIndexService;
import org.gbif.api.service.occurrence.OccurrenceDatasetIndexService;
import org.gbif.api.service.registry2.DatasetSearchService;
import org.gbif.api.service.registry2.DatasetService;
import org.gbif.api.service.registry2.NodeService;

import com.google.inject.Inject;

public class NewsAction extends CountryBaseAction {

  @Inject
  public NewsAction(NodeService nodeService, CubeService cubeService, OccurrenceDatasetIndexService datasetIndexService,
    OccurrenceCountryIndexService countryIndexService, DatasetService datasetService,
    DatasetSearchService datasetSearchService, DatasetMetricsService datasetMetricsService) {
    super(nodeService, cubeService, datasetIndexService, countryIndexService, datasetService, datasetSearchService,
      datasetMetricsService);
  }
}
