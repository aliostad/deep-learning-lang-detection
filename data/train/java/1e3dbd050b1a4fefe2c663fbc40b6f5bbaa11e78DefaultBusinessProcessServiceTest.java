/*
 * [y] hybris Platform
 *
 * Copyright (c) 2000-2013 hybris AG
 * All rights reserved.
 *
 * This software is the confidential and proprietary information of hybris
 * ("Confidential Information"). You shall not disclose such Confidential
 * Information and shall use it only in accordance with the terms of the
 * license agreement you entered into with hybris.
 * 
 *  
 */
package de.hybris.platform.processengine.impl;


import static org.easymock.EasyMock.createNiceMock;
import static org.easymock.EasyMock.expect;
import static org.easymock.EasyMock.replay;
import static org.easymock.EasyMock.verify;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

import de.hybris.bootstrap.annotations.UnitTest;
import de.hybris.platform.processengine.definition.ContextParameterDeclaration;
import de.hybris.platform.processengine.definition.Node;
import de.hybris.platform.processengine.definition.NodeExecutionException;
import de.hybris.platform.processengine.definition.ProcessDefinition;
import de.hybris.platform.processengine.definition.ProcessDefinitionFactory;
import de.hybris.platform.processengine.definition.ProcessDefinitionId;
import de.hybris.platform.processengine.definition.UnsatisfiedContextParameterException;
import de.hybris.platform.processengine.enums.ProcessState;
import de.hybris.platform.processengine.helpers.ProcessFactory;
import de.hybris.platform.processengine.model.BusinessProcessModel;
import de.hybris.platform.servicelayer.model.ModelService;
import de.hybris.platform.task.RetryLaterException;

import java.util.HashMap;
import java.util.Map;

import org.junit.Before;
import org.junit.Test;
import org.springframework.transaction.TransactionException;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;


@UnitTest
public class DefaultBusinessProcessServiceTest
{
	private String processName;
	private String processDefinitionName;
	private Map<String, Object> contextParameters;
	private BusinessProcessModel mockProcessModel;

	private ProcessFactory processFactory;
	private ProcessDefinition mockProcessDefinition;
	private ProcessDefinitionFactory processDefinitionFactory;
	private TransactionTemplate transactionTemplate;
	private ModelService modelService;

	/**
	 * @throws java.lang.Exception
	 */
	@Before
	public void setUp() throws Exception
	{
		processName = "testProcess1";
		processDefinitionName = "testProcess1Definition";

		processFactory = createNiceMock(ProcessFactory.class);
		contextParameters = new HashMap<String, Object>();
		contextParameters.put("P1", Integer.valueOf(1));

		mockProcessModel = new BusinessProcessModel();
		mockProcessModel.setProcessDefinitionName(processDefinitionName);
		mockProcessDefinition = createNiceMock(ProcessDefinition.class);
		processDefinitionFactory = createNiceMock(ProcessDefinitionFactory.class);
		modelService = createNiceMock(ModelService.class);
		// simply delegate call - no real tx logic here
		transactionTemplate = new TransactionTemplate()
		{
			@Override
			public <T extends Object> T execute(final TransactionCallback<T> action) throws TransactionException
			{
				return action.doInTransaction(null);
			}
		};
	}

	/**
	 * Test of correct use of startProcess
	 */
	@Test
	public void testStartProcess()
	{
		final ProcessDefinitionId processDefinitionId = new ProcessDefinitionId("mockDefinition", "mockVersion");
		expect(processFactory.createProcessModel(processName, processDefinitionName, contextParameters))
				.andReturn(mockProcessModel);
		expect(processDefinitionFactory.getProcessDefinition(new ProcessDefinitionId(processDefinitionName))).andReturn(
				mockProcessDefinition);
		expect(mockProcessDefinition.getId()).andReturn(processDefinitionId);

		modelService.save(mockProcessModel);

		mockProcessDefinition.start(mockProcessModel);

		replay(processFactory, processDefinitionFactory, modelService, mockProcessDefinition);
		final DefaultBusinessProcessService defaultService = new DefaultBusinessProcessService()
		{
			@Override
			protected void validateContext(final BusinessProcessModel processModel, final ProcessDefinition processDefinition)
			{
				assertEquals("mockProcessModel not equals to processModel", mockProcessModel, processModel);
				assertEquals("mockProcessDefinition not equals to processDefinition", mockProcessDefinition, processDefinition);
			}
		};
		defaultService.setProcessFactory(processFactory);
		defaultService.setProcessDefinitionFactory(processDefinitionFactory);
		defaultService.setModelService(modelService);
		defaultService.setTransactionTemplate(transactionTemplate);

		defaultService.startProcess(processName, processDefinitionName, contextParameters);
		verify(processFactory, processDefinitionFactory, modelService);
		assertEquals("mockProcessModel.getState() not in RUNNING state", ProcessState.RUNNING, mockProcessModel.getState());
	}

	/**
	 * Test of correct use of startProcess
	 */
	@Test(expected = UnsatisfiedContextParameterException.class)
	public void testStartProcessValidationException()
	{
		expect(processFactory.createProcessModel(processName, processDefinitionName, contextParameters))
				.andReturn(mockProcessModel);
		expect(processDefinitionFactory.getProcessDefinition(new ProcessDefinitionId(processDefinitionName))).andReturn(
				mockProcessDefinition);

		replay(processFactory, processDefinitionFactory);
		final DefaultBusinessProcessService defaultService = new DefaultBusinessProcessService()
		{
			@Override
			protected void validateContext(final BusinessProcessModel processModel, final ProcessDefinition processDefinition)
			{
				assertEquals("mockProcessModel not equals to processModel", mockProcessModel, processModel);
				assertEquals("mockProcessDefinition not equals to processDefinition", mockProcessDefinition, processDefinition);
				throw new UnsatisfiedContextParameterException();
			}
		};
		defaultService.setProcessFactory(processFactory);
		defaultService.setProcessDefinitionFactory(processDefinitionFactory);
		defaultService.setModelService(modelService);
		defaultService.setTransactionTemplate(transactionTemplate);

		defaultService.startProcess(processName, processDefinitionName, contextParameters);
		verify(processFactory, processDefinitionFactory);
	}

	@Test
	public void testValidateContext()
	{
		processDefinitionName = "process1";
		expect(processFactory.createProcessModel(processName, processDefinitionName, contextParameters))
				.andReturn(mockProcessModel);
		expect(processDefinitionFactory.getProcessDefinition(new ProcessDefinitionId(processDefinitionName))).andReturn(
				mockProcessDefinition);
		final Map params = new HashMap<String, ContextParameterDeclaration>();
		final Map nodes = new HashMap<String, Node>();

		final Node node = new Node()
		{

			@Override
			public void trigger(final BusinessProcessModel process)
			{
				//null
			}

			@Override
			public String execute(final BusinessProcessModel process) throws RetryLaterException, NodeExecutionException
			{
				return "OK";
			}

			@Override
			public String getId()
			{
				return "NodeId";
			}

		};
		nodes.put("NodeId", node);
		mockProcessDefinition = new ProcessDefinition(processDefinitionName, node, null, nodes, params,
				"de.hybris.processengine.model.BusinessProcessModel")
		{
			//null
		};

		final DefaultBusinessProcessService defaultService = new DefaultBusinessProcessService();
		try
		{
			defaultService.validateContext(mockProcessModel, mockProcessDefinition);
		}
		catch (final UnsatisfiedContextParameterException exception)
		{
			fail("validateContext throws " + exception.toString());
		}
	}
}
