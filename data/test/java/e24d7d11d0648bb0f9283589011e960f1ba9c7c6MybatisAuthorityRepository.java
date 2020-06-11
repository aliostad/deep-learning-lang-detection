package com.jason.sms.repository.security.impl;

import org.springframework.stereotype.Repository;

import com.jason.framework.orm.mybatis.MybatisRepositorySupport;
import com.jason.sms.domain.security.Authority;
import com.jason.sms.repository.security.AuthorityRepository;

@Repository
public class MybatisAuthorityRepository extends MybatisRepositorySupport<Long, Authority> implements AuthorityRepository {

	@Override
	protected String getNamespace() {
		return "com.jason.sms.domain.security.Authority";
	}}
