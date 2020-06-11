/**
 * 
 */
package com.snyder.review.server.data.repository;

import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.jooq.DSLContext;
import org.jooq.Field;
import org.jooq.Result;
import org.jooq.SQLDialect;
import org.jooq.Table;
import org.jooq.h2.generated.tables.Repository;
import org.jooq.h2.generated.tables.records.RepositoryRecord;

import com.snyder.review.server.data.DataImpl;
import com.snyder.review.shared.model.SecureRepositoryInfo;
import com.snyder.review.shared.model.impl.SecureRepositoryInfoImpl;
import com.snyder.review.shared.versioncontrol.VersionControlClientType;

/**
 * 
 * @author SnyderGP
 */
public class RepositoryDataImpl extends DataImpl implements RepositoryData
{
	
	private static final Table<RepositoryRecord> REPOSITORY = Repository.REPOSITORY;
	private static final Field<Byte> REPOSITORY_ID = Repository.REPOSITORY.REPOSITORY_ID;
	private static final Field<String> REPOSITORY_NAME = Repository.REPOSITORY.REPOSITORY_NAME;
	private static final Field<String> REPOSITORY_URL = Repository.REPOSITORY.REPOSITORY_URL;
	private static final Field<String> REPOSITORY_TYPE_CD = 
		Repository.REPOSITORY.REPOSITORY_TYPE_CD;
	private static final Field<String> REPOSITORY_USERNAME = 
		Repository.REPOSITORY.REPOSITORY_USERNAME;
	private static final Field<String> REPOSITORY_PASSWORD = 
		Repository.REPOSITORY.REPOSITORY_PASSWORD;
	
	
	/**
	 * Converts a JOOQ {@link RepositoryRecord} object to a {@link SecureRepositoryInfo} domain
	 * object
	 * 
	 * @param record
	 * @return
	 */
	private static SecureRepositoryInfo secureRepositoryInfoFromRecord(RepositoryRecord record)
	{
		return new SecureRepositoryInfoImpl(record.getRepositoryId(), 
	    	record.getRepositoryName(), 
	    	record.getRepositoryUrl(), 
	    	VersionControlClientType.fromTypeCode(record.getRepositoryTypeCd()), 
	    	record.getRepositoryUsername(), 
	    	record.getRepositoryPassword());
	}

	/**
	 * @param dataSource
	 * @param dialect
	 */
    public RepositoryDataImpl(DataSource dataSource, SQLDialect dialect)
    {
	    super(dataSource, dialect);
    }

	@Override
    public SecureRepositoryInfo getRepositoryForId(byte repositoryId)
    {
		DSLContext context = this.getDSLContext();
		
		RepositoryRecord record = context.selectFrom(REPOSITORY)
			.where(REPOSITORY_ID.equal(repositoryId))
			.fetchAny();
		
		if(record == null)
		{
			return null;
		}

	    return RepositoryDataImpl.secureRepositoryInfoFromRecord(record);
    }

	@Override
    public List<SecureRepositoryInfo> getAvailableRepositories()
    {
		DSLContext context = this.getDSLContext();
		
		Result<RepositoryRecord> records = context.selectFrom(REPOSITORY).fetch();
		
		List<SecureRepositoryInfo> out = new ArrayList<SecureRepositoryInfo>();
		for(RepositoryRecord record: records)
		{
			out.add(RepositoryDataImpl.secureRepositoryInfoFromRecord(record));
		}
		
		return out;
    }

	@Override
    public byte createRepository(SecureRepositoryInfo repositoryInfo)
    {
		DSLContext context = this.getDSLContext();
		
		RepositoryRecord inserted = context.insertInto(REPOSITORY)
			.set(REPOSITORY_NAME, repositoryInfo.getName())
			.set(REPOSITORY_URL, repositoryInfo.getUrl())
			.set(REPOSITORY_TYPE_CD, repositoryInfo.getType().getTypeCode())
			.set(REPOSITORY_USERNAME, repositoryInfo.getUser())
			.set(REPOSITORY_PASSWORD, repositoryInfo.getPassword())
			.returning(REPOSITORY_ID)
			.fetchOne();
		
		if(inserted == null)
		{
			// TODO custom exception
			throw new IllegalStateException();
		}
		
	    return inserted.getRepositoryId();
    }

	@Override
    public void updateRepository(SecureRepositoryInfo repositoryInfo)
    {
		DSLContext context = this.getDSLContext();
		
		context.update(REPOSITORY)
			.set(REPOSITORY_NAME, repositoryInfo.getName())
			.set(REPOSITORY_URL, repositoryInfo.getUrl())
			.set(REPOSITORY_TYPE_CD, repositoryInfo.getType().getTypeCode())
			.set(REPOSITORY_USERNAME, repositoryInfo.getUser())
			.set(REPOSITORY_PASSWORD, repositoryInfo.getPassword())
			.where(REPOSITORY_ID.equal(repositoryInfo.getId()))
			.execute();
    }

}
