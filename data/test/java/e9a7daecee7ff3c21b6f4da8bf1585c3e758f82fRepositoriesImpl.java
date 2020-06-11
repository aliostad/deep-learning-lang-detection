/**
 * CDDL HEADER START
 *
 * The contents of this file are subject to the terms of the
 * Common Development and Distribution License, Version 1.0 only
 * (the "License").  You may not use this file except in compliance
 * with the License.
 *
 * You can obtain a copy of the license at license/ESCIDOC.LICENSE
 * or https://www.escidoc.org/license/ESCIDOC.LICENSE .
 * See the License for the specific language governing permissions
 * and limitations under the License.
 *
 * When distributing Covered Code, include this CDDL HEADER in each
 * file and include the License file at license/ESCIDOC.LICENSE.
 * If applicable, add the following below this CDDL HEADER, with the
 * fields enclosed by brackets "[]" replaced with your own identifying
 * information: Portions Copyright [yyyy] [name of copyright owner]
 *
 * CDDL HEADER END
 *
 *
 *
 * Copyright 2012 Fachinformationszentrum Karlsruhe Gesellschaft
 * fuer wissenschaftlich-technische Information mbH and Max-Planck-
 * Gesellschaft zur Foerderung der Wissenschaft e.V.
 * All rights reserved.  Use is subject to license terms.
 */
package org.escidoc.browser.repository.internal;

import com.google.common.base.Preconditions;

import org.escidoc.browser.model.EscidocServiceLocation;
import org.escidoc.browser.model.ResourceType;
import org.escidoc.browser.repository.AdminRepository;
import org.escidoc.browser.repository.BulkRepository;
import org.escidoc.browser.repository.GroupRepository;
import org.escidoc.browser.repository.IngestRepository;
import org.escidoc.browser.repository.PdpRepository;
import org.escidoc.browser.repository.Repositories;
import org.escidoc.browser.repository.Repository;
import org.escidoc.browser.repository.RoleRepository;
import org.escidoc.browser.repository.StagingRepository;

import java.net.MalformedURLException;

import de.escidoc.core.client.exceptions.EscidocClientException;

public class RepositoriesImpl implements Repositories {

    private final EscidocServiceLocation serviceLocation;

    private ContextRepository contextRepository;

    private ContainerRepository containerRepository;

    private ItemRepository itemRepository;

    private StagingRepository stagingRepository;

    private PdpRepository pdpRepository;

    private ContentModelRepository contentModelRepository;

    private UserAccountRepository userAccountRepository;

    private AdminRepository adminRepository;

    private IngestRepository ingestRepository;

    private BulkRepository bulkRepo;

    private OrganizationUnitRepository orgUnitRepository;

    private RoleRepository roleRepository;

    private GroupRepository groupRepository;

    public RepositoriesImpl(final EscidocServiceLocation serviceLocation) {
        Preconditions.checkNotNull(serviceLocation, "serviceLocation is null: %s", serviceLocation);
        this.serviceLocation = serviceLocation;
    }

    // TODO find a better way to make this code simpler. Too much repetition.
    public Repositories createAllRepositories() throws MalformedURLException {
        contextRepository = new ContextRepository(serviceLocation);
        containerRepository = new ContainerRepository(serviceLocation);
        itemRepository = new ItemRepository(serviceLocation);
        stagingRepository = new StagingRepositoryImpl(serviceLocation);
        pdpRepository = new PdpRepositoryImpl(serviceLocation.getEscidocUrl());
        contentModelRepository = new ContentModelRepository(serviceLocation);
        userAccountRepository = new UserAccountRepository(serviceLocation);
        adminRepository = new AdminRepository(serviceLocation);
        ingestRepository = new IngestRepository(serviceLocation);
        orgUnitRepository = new OrganizationUnitRepository(serviceLocation);
        groupRepository = new GroupRepository(serviceLocation);
        roleRepository = new RoleRepository(serviceLocation);
        bulkRepo =
            new BulkRepository(contextRepository, containerRepository, itemRepository, contentModelRepository,
                orgUnitRepository, userAccountRepository);
        return this;
    }

    @Override
    public void loginWith(final String token) throws EscidocClientException {
        contextRepository.loginWith(token);
        containerRepository.loginWith(token);
        itemRepository.loginWith(token);
        stagingRepository.loginWith(token);
        pdpRepository.loginWith(token);
        userAccountRepository.loginWith(token);
        adminRepository.loginWith(token);
        ingestRepository.loginWith(token);
        orgUnitRepository.loginWith(token);
        contentModelRepository.loginWith(token);
        groupRepository.loginWith(token);
        roleRepository.loginWith(token);
    }

    @Override
    public ContextRepository context() {
        Preconditions.checkNotNull(contextRepository, "contextRepository is null: %s", contextRepository);
        return contextRepository;
    }

    @Override
    public ContainerRepository container() {
        Preconditions.checkNotNull(containerRepository, "containerRepository is null: %s", containerRepository);
        return containerRepository;
    }

    @Override
    public ItemRepository item() {
        Preconditions.checkNotNull(itemRepository, "itemRepository is null: %s", itemRepository);
        return itemRepository;
    }

    @Override
    public StagingRepository staging() {
        Preconditions.checkNotNull(stagingRepository, "stagingRepository is null: %s", stagingRepository);
        return stagingRepository;
    }

    @Override
    public PdpRepository pdp() {
        Preconditions.checkNotNull(pdpRepository, "pdpRepository is null: %s", pdpRepository);
        return pdpRepository;
    }

    @Override
    public ContentModelRepository contentModel() {
        Preconditions
            .checkNotNull(contentModelRepository, "contentModelRepository is null: %s", contentModelRepository);
        return contentModelRepository;
    }

    @Override
    public UserAccountRepository user() {
        Preconditions.checkNotNull(userAccountRepository, "userAccountRepository is null: %s", userAccountRepository);
        return userAccountRepository;
    }

    @Override
    public AdminRepository admin() {
        Preconditions.checkNotNull(adminRepository, "adminRepository is null: %s", adminRepository);
        return adminRepository;
    }

    @Override
    public IngestRepository ingest() {
        Preconditions.checkNotNull(ingestRepository, "ingestRepository is null: %s", ingestRepository);
        return ingestRepository;
    }

    @Override
    public BulkRepository bulkTasks() {
        return bulkRepo;
    }

    @Override
    public OrganizationUnitRepository organization() {
        return orgUnitRepository;
    }

    @Override
    public Repository findByType(ResourceType type) {
        switch (type) {
            case CONTEXT:
                return contextRepository;
            case CONTAINER:
                return containerRepository;
            case ITEM:
                return itemRepository;
            case CONTENT_MODEL:
                return contentModelRepository;
            case ORG_UNIT:
                return orgUnitRepository;
            case USER_ACCOUNT:
                return userAccountRepository;
            default:
                throw new UnsupportedOperationException("Not yet implemented " + type);
        }
    }

    @Override
    public RoleRepository role() {
        Preconditions.checkNotNull(roleRepository, "roleRepository is null: %s", roleRepository);
        return roleRepository;
    }

    public GroupRepository group() {
        return groupRepository;
    }
}