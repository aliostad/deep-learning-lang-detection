/*
 * Copyright (C) 2009 eXo Platform SAS.
 *
 * This is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 2.1 of
 * the License, or (at your option) any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this software; if not, write to the Free
 * Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA, or see the FSF site: http://www.fsf.org.
 */
package org.exoplatform.services.jcr;

import org.exoplatform.services.jcr.config.RepositoryConfigurationException;
import org.exoplatform.services.jcr.config.RepositoryEntry;
import org.exoplatform.services.jcr.config.RepositoryServiceConfiguration;
import org.exoplatform.services.jcr.core.ManageableRepository;

import javax.jcr.RepositoryException;

/**
 * Created by The eXo Platform SAS<br>
 *
 * The repository service  interface
 * 
 * @author <a href="mailto:geaz@users.sourceforge.net">Gennady Azarenkov</a>
 * @author <a href="mailto:benjamin.mestrallet@exoplatform.com">Benjamin Mestrallet</a>
 * @version $Id: RepositoryService.java 11907 2008-03-13 15:36:21Z ksm $
 * @LevelAPI Provisional
 */
public interface RepositoryService
{

   /**
    * Get default repository.
    * 
    * @return default repository
    * @throws RepositoryException
    * @throws RepositoryConfigurationException
    */
   ManageableRepository getDefaultRepository() throws RepositoryException, RepositoryConfigurationException;

   /**
    * Get repository by name.
    * 
    * @param name
    *          repository name
    * @return repository by name
    * @throws RepositoryException
    * @throws RepositoryConfigurationException
    */
   ManageableRepository getRepository(String name) throws RepositoryException, RepositoryConfigurationException;

   /**
    * Get current repository.
    * 
    * @return ManagableRepository
    * @throws RepositoryException
    */
   ManageableRepository getCurrentRepository() throws RepositoryException;

   /**
    * Set current repository name.
    * 
    * @param repositoryName
    *          repository name
    * @throws RepositoryConfigurationException
    */
   void setCurrentRepositoryName(String repositoryName) throws RepositoryConfigurationException;

   /**
    * Get repository service configuration.
    * 
    * @return RepositoryServiceConfiguration
    */
   RepositoryServiceConfiguration getConfig();

   /**
    * Create new repository .
    * 
    * @param repositoryEntry
    *          repository entry
    * @throws RepositoryConfigurationException
    * @throws RepositoryException
    */
   void createRepository(RepositoryEntry repositoryEntry) throws RepositoryConfigurationException, RepositoryException;

   /**
    * Remove repository with name repositoryName.
    * 
    * @param repositoryName
    *          repository name
    * @throws RepositoryException
    */
   void removeRepository(String repositoryName) throws RepositoryException;

   /**
    * Remove repository with name repositoryName.
    *
    * @param repositoryName
    *          repository name
    * @param forceRemove
    *          will be closed without checking opened session on repository.
    * @throws RepositoryException
    */
   void removeRepository(String repositoryName, boolean forceRemove) throws RepositoryException;

   /**
    * Indicates if repository with name repositoryName can be removed.
    * 
    * @param repositoryName
    *          repository name
    * @return boolean
    * @throws RepositoryException
    */
   boolean canRemoveRepository(String repositoryName) throws RepositoryException;
}
