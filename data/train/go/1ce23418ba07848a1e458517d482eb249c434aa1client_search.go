package riago

// Perform a Riak Search Query request.
func (c *Client) SearchQuery(req *RpbSearchQueryReq) (resp *RpbSearchQueryResp, err error) {
	prof := NewProfile("search_query", string(req.GetIndex()))
	defer c.instrument(prof, err)

	resp = &RpbSearchQueryResp{}
	err = c.do(MsgRpbSearchQueryReq, req, resp, prof)

	return
}

// Perform a Riak Yokozuna Index Get request.
func (c *Client) YokozunaIndexGet(req *RpbYokozunaIndexGetReq) (resp *RpbYokozunaIndexGetResp, err error) {
	prof := NewProfile("yokozuna_index_get", string(req.GetName()))
	defer c.instrument(prof, err)

	resp = &RpbYokozunaIndexGetResp{}
	err = c.do(MsgRpbYokozunaIndexGetReq, req, resp, prof)

	return
}

// Perform a Riak Yokozuna Index Put request.
func (c *Client) YokozunaIndexPut(req *RpbYokozunaIndexPutReq) (err error) {
	prof := NewProfile("yokozuna_index_put", string(req.GetIndex().GetName()))
	defer c.instrument(prof, err)

	err = c.do(MsgRpbYokozunaIndexPutReq, req, nil, prof)

	return
}

// Perform a Riak Yokozuna Index Delete request.
func (c *Client) YokozunaIndexDelete(req *RpbYokozunaIndexDeleteReq) (err error) {
	prof := NewProfile("yokozuna_index_delete", string(req.GetName()))
	defer c.instrument(prof, err)

	err = c.do(MsgRpbYokozunaIndexDeleteReq, req, nil, prof)

	return
}

// Perform a Riak Yokozuna Index Get request.
func (c *Client) YokozunaSchemaGet(req *RpbYokozunaSchemaGetReq) (resp *RpbYokozunaSchemaGetResp, err error) {
	prof := NewProfile("yokozuna_schema_get", string(req.GetName()))
	defer c.instrument(prof, err)

	resp = &RpbYokozunaSchemaGetResp{}
	err = c.do(MsgRpbYokozunaSchemaGetReq, req, resp, prof)

	return
}

// Perform a Riak Yokozuna Schema Put request.
func (c *Client) YokozunaSchemaPut(req *RpbYokozunaSchemaPutReq) (err error) {
	prof := NewProfile("yokozuna_schema_put", string(req.GetSchema().GetName()))
	defer c.instrument(prof, err)

	err = c.do(MsgRpbYokozunaSchemaPutReq, req, nil, prof)

	return
}
