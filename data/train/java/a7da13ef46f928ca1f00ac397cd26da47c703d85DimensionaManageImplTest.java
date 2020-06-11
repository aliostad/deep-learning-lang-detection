/**
 * 
 */
package com.ystech.springsecurity.service;

import javax.annotation.Resource;

import org.junit.Test;
import org.springframework.stereotype.Component;

import com.ystech.aqtp.model.Breed;
import com.ystech.aqtp.model.ChickenBatch;
import com.ystech.aqtp.model.Dimensiona;
import com.ystech.aqtp.model.Grade;
import com.ystech.aqtp.service.BreaderBreedManageImpl;
import com.ystech.aqtp.service.BreedManageImpl;
import com.ystech.aqtp.service.BreederManageImpl;
import com.ystech.aqtp.service.ChickenBatchManageImpl;
import com.ystech.aqtp.service.DimensionaManageImpl;
import com.ystech.aqtp.service.GradeManageImpl;
import com.ystech.aqtp.service.UserManageImpl;
import com.ystech.core.dao.HibernateEntityDao;
import com.ystech.core.test.SpringTxTestCase;
import com.ystech.core.util.TestGenerateUtil;

/**
 * @author shusanzhan
 * @date 2013-6-22
 */
public class DimensionaManageImplTest extends SpringTxTestCase{
	private DimensionaManageImpl dimensionaManageImpl;

	@Resource
	public void setDimensionaManageImpl(DimensionaManageImpl dimensionaManageImpl) {
		this.dimensionaManageImpl = dimensionaManageImpl;
	}
	private BreaderBreedManageImpl breaderBreedManageImpl;
	private ChickenBatchManageImpl chickenBatchManageImpl;
	private UserManageImpl userManageImpl;
	private BreederManageImpl breederManageImpl;
	@Resource
	public void setUserManageImpl(UserManageImpl userManageImpl) {
		this.userManageImpl = userManageImpl;
	}
	@Resource
	public void setBreederManageImpl(BreederManageImpl breederManageImpl) {
		this.breederManageImpl = breederManageImpl;
	}
	@Resource
	public void setBreaderBreedManageImpl(
			BreaderBreedManageImpl breaderBreedManageImpl) {
		this.breaderBreedManageImpl = breaderBreedManageImpl;
	}

	@Resource
	public void setChickenBatchManageImpl(
			ChickenBatchManageImpl chickenBatchManageImpl) {
		this.chickenBatchManageImpl = chickenBatchManageImpl;
	}
	private BreedManageImpl breedManageImpl;

	@Resource
	public void setBreedManageImpl(BreedManageImpl breedManageImpl) {
		this.breedManageImpl = breedManageImpl;
	}
	private GradeManageImpl gradeManageImpl;

	@Resource
	public void setGradeManageImpl(GradeManageImpl gradeManageImpl) {
		this.gradeManageImpl = gradeManageImpl;
	}
	@Test
	public void testCRUD() throws Exception {
		
		//create
		ChickenBatch chickenBatch=new ChickenBatch();
		Breed breed=new Breed();
		breed.setName("name");
		breed.setCharacteristic("characteristic");
		breed.setNote("note");
		breed.setCharCode("charCode");

		breedManageImpl.save(breed);
		
		//create
		Grade grade=new Grade();

		grade.setName("name");
		grade.setLevel("level");
		grade.setNote("note");
		grade.setRetailPrice(Float.valueOf("1.0"));

		gradeManageImpl.save(grade);
		
		chickenBatch.setBreed(breed);
		chickenBatch.setGrade(grade);
		chickenBatch.setBatchNo("batchNo");
		chickenBatch.setName("name");
		chickenBatch.setBirthday(new java.util.Date());
		chickenBatch.setAge(1);
		chickenBatch.setOutBarDate(new java.util.Date());
		chickenBatch.setIntoBarDate(new java.util.Date());




		chickenBatchManageImpl.save(chickenBatch);
				
		//create
		Dimensiona dimensiona=new Dimensiona();

	
		dimensiona.setChickenbatch(chickenBatch);
		dimensiona.setName("name");
		dimensiona.setCreateDate(new java.util.Date());
		dimensiona.setQuantity(1);

		dimensionaManageImpl.save(dimensiona);
		assertNotNull(dimensiona.getDbid());
		//get
		dimensiona=dimensionaManageImpl.get(dimensiona.getDbid());
		assertNotNull(dimensiona.getDbid());
		assertEquals("name",dimensiona.getName());
		assertNotNull(dimensiona.getCreateDate());
		assertEquals(new Integer(1),dimensiona.getQuantity());

		//update
		dimensiona.setName("name1");
		dimensionaManageImpl.save(dimensiona);
		dimensiona=dimensionaManageImpl.get(dimensiona.getDbid());
		assertNotNull(dimensiona.getDbid());
		assertEquals("name1",dimensiona.getName());
		assertNotNull(dimensiona.getCreateDate());
		assertEquals(new Integer(1),dimensiona.getQuantity());

		//delete
		dimensionaManageImpl.deleteById(dimensiona.getDbid());

	}
	public static void main(String[] args) {
		TestGenerateUtil.generate(Dimensiona.class);
	}
	
}
