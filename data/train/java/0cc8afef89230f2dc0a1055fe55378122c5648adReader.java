package ninja.hudy.infosmog.reader;

import ninja.hudy.infosmog.repository.CityRepository;
import ninja.hudy.infosmog.repository.MeasurementRepository;
import ninja.hudy.infosmog.repository.MeasurementTypeRepository;
import ninja.hudy.infosmog.repository.StationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

public abstract class Reader {
    @Autowired
    protected MeasurementTypeRepository measurementTypeRepository;

    @Autowired
    protected MeasurementRepository measurementRepository;

    @Autowired
    protected StationRepository stationRepository;

    @Autowired
    protected CityRepository cityRepository;

    @Transactional
    public abstract void read();
}
