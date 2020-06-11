/*
 * Copyright 2004-2008 the Seasar Foundation and the Others.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
 * either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 */
package org.seasar.karrta.jcr.repository;

import java.io.File;
import java.io.IOException;

import javax.jcr.Repository;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.jackrabbit.api.JackrabbitRepository;
import org.apache.jackrabbit.core.TransientRepository;
import org.apache.jackrabbit.core.config.ConfigurationException;
import org.apache.jackrabbit.core.config.RepositoryConfig;
import org.seasar.karrta.jcr.exception.JcrRepositoryRuntimeException;

/**
 * 
 * @author yosuke
 * 
 */
public class JcrRepository {
    private static final Log logger_ = LogFactory.getLog(JcrRepository.class);

    public JcrRepository() {}
    
    /** Default repository configuration file. */
    private static final String DEFAULT_CONF_FILE = "repository.xml";
    
    /** Default repository directory. */
    private static final String DEFAULT_REP_DIR = ".";

    /** configuration file name */
    private String repositoryConfigFile_ = "";
    
    /** repository home directory */
    private String repositoryHomeDir_ = "";
    
    /**
     * initialize repository.
     * 
     * @param repositoryConfigFile
     * @param repositoryHomeDir
     * @param senHomeDir
     */
    public void init(String repositoryConfigFile, String repositoryHomeDir, String senHomeDir) {
        this.repositoryConfigFile_ = repositoryConfigFile;
        this.repositoryHomeDir_ = repositoryHomeDir;
        System.setProperty("sen.home", senHomeDir);
        
        logger_.debug("::: JcrRepository#init :::");
        logger_.debug("::: repositoryConfigFile:[" + repositoryConfigFile + "] :::");
        logger_.debug(":::    repositoryHomeDir:[" + repositoryHomeDir    + "] :::");
        logger_.debug(":::           senHomeDir:[" + senHomeDir           + "] :::");
        logger_.debug("---");
    }

    /**
     * destroy repository.
     */
    public void destroy() {
        logger_.debug("::: JcrRepository#destroy :::");

        if (this.repository_ instanceof JackrabbitRepository) {
            ((JackrabbitRepository) this.repository_).shutdown();
        }
    }

    /** repository */
    protected Repository repository_;

    /**
     * create repository.
     * 
     * @return
     * @throws JcrRepositoryRuntimeException
     */
    public Repository createRepository() throws JcrRepositoryRuntimeException {
        logger_.debug("::: JcrRepository#createRepository :::");

        try {
            if (this.repository_ == null) {
                if (this.repositoryConfigFile_ == null || "".equals(this.repositoryConfigFile_)) {
                    this.repositoryConfigFile_ = DEFAULT_CONF_FILE;
                }
                if (this.repositoryHomeDir_ == null || "".equals(this.repositoryHomeDir_)) {
                    this.repositoryHomeDir_ = DEFAULT_REP_DIR;
                }
                RepositoryConfig repositoryConfig = RepositoryConfig.create(this.repositoryConfigFile_,
                    new File(this.repositoryHomeDir_).getAbsolutePath());

                this.repository_ = new TransientRepository(repositoryConfig);
            }
            return repository_;

        } catch (ConfigurationException e) {
            throw new JcrRepositoryRuntimeException("", e);
        } catch (IOException e) {
            throw new JcrRepositoryRuntimeException("", e);
        }
    }

}
