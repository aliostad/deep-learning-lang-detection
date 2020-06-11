#pragma once
#include "FixedWidthChunk.h"
#include "pack.h"
#include "string"
#include "map"
#include "vector"

using std::string;
using std::map;
using std::vector;

class DoclenChunkReader;
class DoclenChunkWriter;

class DoclenChunkWriter
{
private:

	const string& chunk_from;
	const map<docid,doclen>& changes;
	BTree* b_tree;
	bool is_first_chunk;
	bool is_last_chunk;
	map<docid,doclen> new_doclen;

	bool get_new_doclen( const map<docid,doclen>*& p_new_doclen );
public:
	DoclenChunkWriter( const string& chunk_from_, 
		const map<docid,doclen>& changes_, 
		BTree* b_tree_,
		bool is_first_chunk_ )
		: chunk_from(chunk_from_), changes(changes_), b_tree(b_tree_), is_first_chunk(is_first_chunk_)
	{
		is_last_chunk = true;
	}
	bool merge_doclen_changes( );
};

class DoclenChunkReader
{
private:
	string chunk;
	FixedWidthChunkReader* p_fwcr;
public:
	DoclenChunkReader( const string& chunk_, bool is_first_chunk );
	~DoclenChunkReader()
	{
		if ( p_fwcr!= NULL )
		{
			delete p_fwcr;
			p_fwcr = NULL;
		}
	}
	docid get_doclen( docid desired_did );
};