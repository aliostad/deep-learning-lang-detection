package com.hieugie.cookingtime.service;

import org.springframework.beans.factory.annotation.Autowired;

import com.hieugie.cookingtime.repository.DishRepository;
import com.hieugie.cookingtime.repository.GenderRepository;
import com.hieugie.cookingtime.repository.InstructionRepository;
import com.hieugie.cookingtime.repository.LikeRepository;
import com.hieugie.cookingtime.repository.MaterialRepository;
import com.hieugie.cookingtime.repository.MaterialTypeRepository;
import com.hieugie.cookingtime.repository.MeasureRepository;
import com.hieugie.cookingtime.repository.UserRepository;

public abstract class BaseService {

	@Autowired
	public UserRepository userRepository;

	@Autowired
	public GenderRepository genderRepository;

	@Autowired
	public DishRepository dishRepository;

	@Autowired
	public LikeRepository likeRepository;

	@Autowired
	public InstructionRepository instructionRepository;

	@Autowired
	public MaterialRepository materialRepository;

	@Autowired
	public MaterialTypeRepository materialTypeRepository;
	@Autowired
	public MeasureRepository measureRepository;

}
