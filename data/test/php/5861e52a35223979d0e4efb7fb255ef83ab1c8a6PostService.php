<?php
class PostService {
	function getPostViaCategories($categoryId, $isGetChild) {
		$categoryRepository = new CategoryRepository ();
		$categoryRepository->id = $categoryId;
		$result = $categoryRepository->getMutilCondition ();
		if (! $isGetChild) {
			$postRepository = new PostRepository ();
			$postRepository->category_id = $result [0]->id;
			return $postRepository->getMutilCondition ( T_post::created_at );
		}
		$categoryRepository = new CategoryRepository ();
		$categoryRepository->part_url = $result [0]->part_tree;
		$result = $categoryRepository->getWhereLike ( T_category::part_tree, 'after' );
	}
}