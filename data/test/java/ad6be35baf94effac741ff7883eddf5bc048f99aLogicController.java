package net.vurs.service.definition.logic;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import net.vurs.service.definition.NeighbourhoodService;
import net.vurs.service.definition.ClusterService;
import net.vurs.service.definition.ConceptService;
import net.vurs.service.definition.EntityService;
import net.vurs.service.definition.ExternalService;
import net.vurs.service.definition.GeoService;
import net.vurs.service.definition.LogicService;
import net.vurs.service.definition.NLPService;

public class LogicController {
	protected final Logger logger = LoggerFactory.getLogger(getClass());
	
	protected EntityService entityService = null;
	protected ClusterService clusterService = null;
	protected LogicService logicService = null;
	protected NLPService nlpService = null;
	protected ExternalService externalService = null;
	protected GeoService geoService = null;
	protected ConceptService conceptService = null;
	protected NeighbourhoodService neighbourhoodService = null;
	
	public void setup(EntityService entityService, ClusterService clusterService, NLPService nlpService, ExternalService externalService, GeoService geoService, ConceptService conceptService, NeighbourhoodService neighbourhoodService, LogicService logicService) {
		this.entityService = entityService;
		this.clusterService = clusterService;
		this.nlpService = nlpService;
		this.logicService = logicService;
		this.externalService = externalService;
		this.geoService = geoService;
		this.conceptService = conceptService;
		this.neighbourhoodService = neighbourhoodService;
	}

	public void init() {
	}
	
}
