package com.blog.base.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.blog.base.entity.Post;
import com.blog.base.repository.CategoryRepository;
import com.blog.base.repository.PostRepository;

@Service
public class SearchService {
	
	@Autowired
	private PostRepository postRepository;
	
	@Autowired
	private CategoryRepository categoryRepository;
	
	
	public List<Post> Search(String searchContext){
		
List<Post> searchList=postRepository.findByPostTextContains(searchContext);
	    
		
		
		return searchList;
		
	}


	public PostRepository getPostRepository() {
		return postRepository;
	}


	public void setPostRepository(PostRepository postRepository) {
		this.postRepository = postRepository;
	}


	public CategoryRepository getCategoryRepository() {
		return categoryRepository;
	}


	public void setCategoryRepository(CategoryRepository categoryRepository) {
		this.categoryRepository = categoryRepository;
	}
	

}
