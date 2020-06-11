package riago

// Performs a Riak CRDT Fetch request.
func (c *Client) DtFetch(req *DtFetchReq) (resp *DtFetchResp, err error) {
	prof := NewProfile("dt_fetch", string(req.GetBucket()))
	defer c.instrument(prof, err)

	resp = &DtFetchResp{}
	err = c.retry(func() error {
		return c.do(MsgDtFetchReq, req, resp, prof)
	}, prof)

	return
}

// Performs a Riak CRDT Update request.
func (c *Client) DtUpdate(req *DtUpdateReq) (resp *DtUpdateResp, err error) {
	prof := NewProfile("dt_update", string(req.GetBucket()))
	defer c.instrument(prof, err)

	resp = &DtUpdateResp{}
	err = c.retry(func() error {
		return c.do(MsgDtUpdateReq, req, resp, prof)
	}, prof)

	return
}
