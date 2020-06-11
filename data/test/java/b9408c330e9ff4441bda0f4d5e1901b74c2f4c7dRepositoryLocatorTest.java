package ca.ulaval.ift6002.m2.infrastructure.persistence.locator;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;

import org.junit.Before;
import org.junit.Test;

import ca.ulaval.ift6002.m2.domain.drug.DrugRepository;
import ca.ulaval.ift6002.m2.domain.patient.PatientRepository;
import ca.ulaval.ift6002.m2.domain.surgery.SurgeryRepository;
import ca.ulaval.ift6002.m2.locator.RepositoryLocator;

public class RepositoryLocatorTest {

    private static final DrugRepository DRUG_REPOSITORY_IMPLEMENTATION = mock(DrugRepository.class);
    private static final SurgeryRepository SURGERY_REPOSITORY_IMPLEMENTATION = mock(SurgeryRepository.class);
    private static final PatientRepository PATIENT_REPOSITORY_IMPLEMENTATION = mock(PatientRepository.class);

    @Before
    public void setUp() {
        RepositoryLocator locator = new RepositoryLocator();

        locator.register(DrugRepository.class, DRUG_REPOSITORY_IMPLEMENTATION);
        locator.register(SurgeryRepository.class, SURGERY_REPOSITORY_IMPLEMENTATION);
        locator.register(PatientRepository.class, PATIENT_REPOSITORY_IMPLEMENTATION);

        RepositoryLocator.load(locator);
    }

    @Test
    public void givenLocatorWhenGettingDrugRepositoryShouldReturnAnInstanceOfDrugRepository() {
        DrugRepository drugRepositoryFound = RepositoryLocator.getDrugRepository();

        assertEquals(DRUG_REPOSITORY_IMPLEMENTATION, drugRepositoryFound);
    }

    @Test
    public void givenLocatorWhenGettingSurgeryRepositoryShouldReturnAnInstanceOfSurgeryRepository() {
        SurgeryRepository surgeryRepositoryFound = RepositoryLocator.getSurgeryRepository();

        assertEquals(SURGERY_REPOSITORY_IMPLEMENTATION, surgeryRepositoryFound);
    }

    @Test
    public void givenLocatorWhenGettingPatientRepositoryShouldReturnAnInstanceOfPatientRepository() {
        PatientRepository patientRepositoryFound = RepositoryLocator.getPatientRepository();

        assertEquals(PATIENT_REPOSITORY_IMPLEMENTATION, patientRepositoryFound);
    }
}
