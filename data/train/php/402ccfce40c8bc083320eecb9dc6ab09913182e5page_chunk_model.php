<?php

class Page_chunk_model extends MY_Model {
    
    /**
	 * Create page chunks
	 *
	 * @access 	public
	 * @param 	array 	$input The sanitized $_POST
	 * @return 	bool
	 */
	public function create($input)
	{
		$chunk_slugs 	= $input['chunk_slug'] ? array_values($input['chunk_slug']) : array();
		$chunk_bodies 	= $input['chunk_body'] ? array_values($input['chunk_body']) : array();
		$chunk_types 	= $input['chunk_type'] ? array_values($input['chunk_type']) : array();

		$page->chunks = array();
		$chunk_bodies_count = count($input['chunk_body']);
		for ($i = 0; $i < $chunk_bodies_count; $i++)
		{
			$page->chunks[] = (object) array(
				'id' => $i,
				'slug' => ! empty($chunk_slugs[$i]) ? $chunk_slugs[$i] : '',
				'type' => ! empty($chunk_types[$i]) ? $chunk_types[$i] : '',
				'body' => ! empty($chunk_bodies[$i]) ? $chunk_bodies[$i] : '',
			);
		}

		if ($page->chunks)
		{
			// get rid of the old
            $this->set_soft_deletes(false);
			$this->delete_where(array('page_id' => $input['id']));

			// And add the new ones
			$i = 1;
            $this->set_created(false);
			foreach ($page->chunks as $chunk)
			{
				$this->insert(array(
					'slug' 		=> preg_replace('/[^a-zA-Z0-9_-\s]/', '', $chunk->slug),
					'page_id' 	=> $input['id'],
					'body' 		=> $chunk->body,
					'parsed'	=> ($chunk->type == 'markdown') ? parse_markdown($chunk->body) : '',
					'type' 		=> $chunk->type,
					'sort' 		=> $i++,
				));
			}

			return TRUE;
		}

		return FALSE;
	}
}