package com.baekgom.dao;

import java.util.List;

import com.baekgom.repository.BaseRepository;
import com.baekgom.vo.VO;

public abstract class BaseDAO<T> {

	protected BaseRepository<T> baseRepository;

	public BaseDAO(BaseRepository<T> childRepository) {
		baseRepository = childRepository;
	}

	public abstract VO findOne(Long id);

	public List<T> findAll() {
		return baseRepository.repository;
	}

	@SuppressWarnings("unchecked")
	public boolean insert(T vo) {

		if (vo != null) {

			VO valueObject;

			if (baseRepository.repository.isEmpty()) {
				valueObject = (VO) vo;
				valueObject.setId(0L);
				baseRepository.repository.add((T) valueObject);
				return true;
			} else {
				if (!baseRepository.repository.contains(vo)) {
					VO repositoryGetValue = (VO) baseRepository.repository
							.get(baseRepository.repository.size() - 1);
					valueObject = (VO) vo;
					valueObject.setId(((long) repositoryGetValue.getId() + 1L));
					baseRepository.repository.add((T) valueObject);
					return true;
				}
			}

		}

		return false;
	}

	public boolean update(T vo) {

		if (baseRepository.repository.contains(vo)) {
			baseRepository.repository.set(
					baseRepository.repository.indexOf(vo), vo);
			return true;
		}

		return false;
	}

	public boolean delete(T vo) {

		if (baseRepository.repository.contains(vo)) {
			baseRepository.repository.remove(baseRepository.repository
					.indexOf(vo));
			return true;
		}

		return false;
	}

}
