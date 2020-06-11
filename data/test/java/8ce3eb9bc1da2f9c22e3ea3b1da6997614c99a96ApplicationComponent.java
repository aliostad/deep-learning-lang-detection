package com.tamerbarsbay.depothouston.presentation.internal.di.components;

import android.content.Context;

import com.tamerbarsbay.depothouston.domain.executor.PostExecutionThread;
import com.tamerbarsbay.depothouston.domain.executor.ThreadExecutor;
import com.tamerbarsbay.depothouston.domain.repository.ArrivalRepository;
import com.tamerbarsbay.depothouston.domain.repository.IncidentRepository;
import com.tamerbarsbay.depothouston.domain.repository.ItineraryRepository;
import com.tamerbarsbay.depothouston.domain.repository.RouteRepository;
import com.tamerbarsbay.depothouston.domain.repository.StopRepository;
import com.tamerbarsbay.depothouston.domain.repository.VehicleRepository;
import com.tamerbarsbay.depothouston.presentation.internal.di.modules.ApplicationModule;
import com.tamerbarsbay.depothouston.presentation.view.activity.BaseActivity;

import javax.inject.Singleton;

import dagger.Component;

@Singleton
@Component(modules = ApplicationModule.class)
public interface ApplicationComponent {

    void inject(BaseActivity baseActivity);

    // Exposed to subgraphs
    Context context();
    ThreadExecutor threadExecutor();
    PostExecutionThread postExecutionThread();
    RouteRepository routeRepository();
    StopRepository stopRepository();
    ArrivalRepository arrivalRepository();
    IncidentRepository incidentRepository();
    ItineraryRepository itineraryRepository();
    VehicleRepository vehicleRepository();

}
