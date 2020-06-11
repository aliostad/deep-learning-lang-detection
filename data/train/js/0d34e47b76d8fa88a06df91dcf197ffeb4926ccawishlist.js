import request from 'superagent';

export default {
    /**
     * Fetch data
     * @param  {Function} dispatch
     * @return {Void}
     */
    fetch(dispatch) {
        return new Promise((done, fail) => {
            request
                .get('http://localhost:3000/api/wishlist')
                .end((err, res) => {
                    dispatch('WISHLIST_FETCHED', res.body);
                    done();
                });
        });
    },

    /**
     * Store item to wishlist
     * @param  {Function} dispatch
     * @param  {Number} id
     * @return {Void}
     */
    add(dispatch, id) {
        request
            .post('http://localhost:3000/api/wishlist')
            .send({ _id: id })
            .end((err, res) => {
                if (err || res.error) {
                    dispatch('ITEM_STORE_ERROR', err || res.error);
                } else {
                    dispatch('ITEM_STORED', res.body);
                }
            });
    }
};