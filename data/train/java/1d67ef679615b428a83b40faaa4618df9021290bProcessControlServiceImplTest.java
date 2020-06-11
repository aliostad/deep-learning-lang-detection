/*


 */
package net.atos.transport.business.service.impl;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;

import net.atos.transport.entity.ProcessControl;
import net.atos.transport.entity.jpa.ProcessControlEntity;
import net.atos.transport.business.service.mapping.ProcessControlServiceMapper;
import net.atos.transport.data.repository.jpa.ProcessControlJpaRepository;
import net.atos.transport.test.ProcessControlFactoryForTest;
import net.atos.transport.test.ProcessControlEntityFactoryForTest;
import net.atos.transport.test.MockValues;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

/**
 * Test : Implementation of ProcessControlService
 */
@RunWith(MockitoJUnitRunner.class)
public class ProcessControlServiceImplTest
{

    @InjectMocks
    private ProcessControlServiceImpl processControlService;

    @Mock
    private ProcessControlJpaRepository processControlJpaRepository;

    @Mock
    private ProcessControlServiceMapper processControlServiceMapper;

    private ProcessControlFactoryForTest processControlFactoryForTest = new ProcessControlFactoryForTest();

    private ProcessControlEntityFactoryForTest processControlEntityFactoryForTest = new ProcessControlEntityFactoryForTest();

    private MockValues mockValues = new MockValues();

    @Test
    public void findById()
    {
        // Given
        Integer processId = mockValues.nextInteger();

        ProcessControlEntity processControlEntity = processControlJpaRepository.findOne(processId);

        ProcessControl processControl = processControlFactoryForTest.newProcessControl();
        when(processControlServiceMapper.mapProcessControlEntityToProcessControl(processControlEntity)).thenReturn(
                processControl);

        // When
        ProcessControl processControlFound = processControlService.findById(processId);

        // Then
        assertEquals(processControl.getProcessId(), processControlFound.getProcessId());
    }

    @Test
    public void findAll()
    {
        // Given
        List<ProcessControlEntity> processControlEntitys = new ArrayList<ProcessControlEntity>();
        ProcessControlEntity processControlEntity1 = processControlEntityFactoryForTest.newProcessControlEntity();
        processControlEntitys.add(processControlEntity1);
        ProcessControlEntity processControlEntity2 = processControlEntityFactoryForTest.newProcessControlEntity();
        processControlEntitys.add(processControlEntity2);
        when(processControlJpaRepository.findAll()).thenReturn(processControlEntitys);

        ProcessControl processControl1 = processControlFactoryForTest.newProcessControl();
        when(processControlServiceMapper.mapProcessControlEntityToProcessControl(processControlEntity1)).thenReturn(
                processControl1);
        ProcessControl processControl2 = processControlFactoryForTest.newProcessControl();
        when(processControlServiceMapper.mapProcessControlEntityToProcessControl(processControlEntity2)).thenReturn(
                processControl2);

        // When
        List<ProcessControl> processControlsFounds = processControlService.findAll();

        // Then
        assertTrue(processControl1 == processControlsFounds.get(0));
        assertTrue(processControl2 == processControlsFounds.get(1));
    }

    @Test
    public void create()
    {
        // Given
        ProcessControl processControl = processControlFactoryForTest.newProcessControl();

        ProcessControlEntity processControlEntity = processControlEntityFactoryForTest.newProcessControlEntity();
        when(processControlJpaRepository.findOne(processControl.getProcessId())).thenReturn(null);

        processControlEntity = new ProcessControlEntity();
        processControlServiceMapper.mapProcessControlToProcessControlEntity(processControl, processControlEntity);
        ProcessControlEntity processControlEntitySaved = processControlJpaRepository.save(processControlEntity);

        ProcessControl processControlSaved = processControlFactoryForTest.newProcessControl();
        when(processControlServiceMapper.mapProcessControlEntityToProcessControl(processControlEntitySaved))
                .thenReturn(processControlSaved);

        // When
        ProcessControl processControlResult = processControlService.create(processControl);

        // Then
        assertTrue(processControlResult == processControlSaved);
    }

    @Test
    public void createKOExists()
    {
        // Given
        ProcessControl processControl = processControlFactoryForTest.newProcessControl();

        ProcessControlEntity processControlEntity = processControlEntityFactoryForTest.newProcessControlEntity();
        when(processControlJpaRepository.findOne(processControl.getProcessId())).thenReturn(processControlEntity);

        // When
        Exception exception = null;
        try
        {
            processControlService.create(processControl);
        }
        catch (Exception e)
        {
            exception = e;
        }

        // Then
        assertTrue(exception instanceof IllegalStateException);
        assertEquals("already.exists", exception.getMessage());
    }

    @Test
    public void update()
    {
        // Given
        ProcessControl processControl = processControlFactoryForTest.newProcessControl();

        ProcessControlEntity processControlEntity = processControlEntityFactoryForTest.newProcessControlEntity();
        when(processControlJpaRepository.findOne(processControl.getProcessId())).thenReturn(processControlEntity);

        ProcessControlEntity processControlEntitySaved = processControlEntityFactoryForTest.newProcessControlEntity();
        when(processControlJpaRepository.save(processControlEntity)).thenReturn(processControlEntitySaved);

        ProcessControl processControlSaved = processControlFactoryForTest.newProcessControl();
        when(processControlServiceMapper.mapProcessControlEntityToProcessControl(processControlEntitySaved))
                .thenReturn(processControlSaved);

        // When
        ProcessControl processControlResult = processControlService.update(processControl);

        // Then
        verify(processControlServiceMapper).mapProcessControlToProcessControlEntity(processControl,
                processControlEntity);
        assertTrue(processControlResult == processControlSaved);
    }

    @Test
    public void delete()
    {
        // Given
        Integer processId = mockValues.nextInteger();

        // When
        processControlService.delete(processId);

        // Then
        verify(processControlJpaRepository).delete(processId);

    }

}
