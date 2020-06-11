import BaseModel from '../base';
import Ships     from '../record/ships';

class RepairDock extends BaseModel {
    constructor() {
        super();
        this.modelname = 'RepairDock';
    }
    parse(api_data) {
        let dock = {
            id      : api_data.api_id,
            state   : api_data.api_state,
            shipid  : api_data.api_ship_id,
            ship    : api_data.api_ship_id === 0 ? null : Ships.get(api_data.api_ship_id),
            complate: api_data.api_complete_time
        };
        return dock;
    }
}

export default new RepairDock();
