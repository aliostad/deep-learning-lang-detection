// 
// Decompiled by Procyon v0.5.29
// 

package com.newrelic.agent.service;

import com.newrelic.agent.utilization.UtilizationService;
import com.newrelic.agent.circuitbreaker.CircuitBreakerService;
import com.newrelic.agent.service.async.AsyncTransactionService;
import com.newrelic.agent.service.analytics.InsightsService;
import com.newrelic.agent.attributes.AttributesService;
import com.newrelic.agent.xray.IXRaySessionService;
import com.newrelic.agent.reinstrument.RemoteInstrumentationService;
import com.newrelic.agent.normalization.NormalizationService;
import com.newrelic.agent.stats.StatsService;
import com.newrelic.agent.instrumentation.ClassTransformerService;
import com.newrelic.agent.environment.EnvironmentService;
import com.newrelic.agent.rpm.RPMConnectionService;
import com.newrelic.agent.config.ConfigService;
import com.newrelic.agent.IAgent;
import com.newrelic.agent.samplers.SamplerService;
import com.newrelic.agent.RPMServiceManager;
import com.newrelic.agent.commands.CommandParser;
import com.newrelic.agent.service.analytics.TransactionEventsService;
import com.newrelic.agent.jmx.JmxService;
import com.newrelic.agent.service.module.JarCollectorService;
import com.newrelic.agent.TransactionService;
import com.newrelic.agent.database.DatabaseService;
import com.newrelic.agent.cache.CacheService;
import com.newrelic.agent.browser.BrowserService;
import com.newrelic.agent.sql.SqlTraceService;
import com.newrelic.agent.HarvestService;
import com.newrelic.agent.ThreadService;
import com.newrelic.agent.trace.TransactionTraceService;
import com.newrelic.agent.TracerService;
import com.newrelic.agent.profile.ProfilerService;
import com.newrelic.agent.extension.ExtensionService;
import java.util.Map;

public interface ServiceManager extends Service
{
    Map<String, Map<String, Object>> getServicesConfiguration();
    
    void addService(Service p0);
    
    Service getService(String p0);
    
    ExtensionService getExtensionService();
    
    ProfilerService getProfilerService();
    
    TracerService getTracerService();
    
    TransactionTraceService getTransactionTraceService();
    
    ThreadService getThreadService();
    
    HarvestService getHarvestService();
    
    SqlTraceService getSqlTraceService();
    
    BrowserService getBrowserService();
    
    CacheService getCacheService();
    
    DatabaseService getDatabaseService();
    
    TransactionService getTransactionService();
    
    JarCollectorService getJarCollectorService();
    
    JmxService getJmxService();
    
    TransactionEventsService getTransactionEventsService();
    
    CommandParser getCommandParser();
    
    RPMServiceManager getRPMServiceManager();
    
    SamplerService getSamplerService();
    
    IAgent getAgent();
    
    ConfigService getConfigService();
    
    RPMConnectionService getRPMConnectionService();
    
    EnvironmentService getEnvironmentService();
    
    ClassTransformerService getClassTransformerService();
    
    StatsService getStatsService();
    
    NormalizationService getNormalizationService();
    
    RemoteInstrumentationService getRemoteInstrumentationService();
    
    IXRaySessionService getXRaySessionService();
    
    AttributesService getAttributesService();
    
    InsightsService getInsights();
    
    AsyncTransactionService getAsyncTxService();
    
    CircuitBreakerService getCircuitBreakerService();
    
    UtilizationService getUtilizationService();
}
