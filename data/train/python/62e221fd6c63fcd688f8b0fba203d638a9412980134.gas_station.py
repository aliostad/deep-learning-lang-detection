class Solution:
    # @param gas, a list of integers
    # @param cost, a list of integers
    # @return an integer
    def canCompleteCircuit(self, gas, cost):
        gl = len(gas)
        gas_save_list = [0] * (gl * 2)
        gas_save_total = 0
        for i in range(gl):
            gas_save_list[i] = gas[i] - cost[i]
            gas_save_list[i+gl] = gas_save_list[i]
            gas_save_total += gas_save_list[i]
        if gas_save_total < 0:
            return -1

        # do a search
        gas_save = None
        start, end = -1, -1
        _g, _s = 0, 0

        for idx, i in enumerate(gas_save_list):
            _g += i
            if (gas_save is None) or (_g > gas_save):
                gas_save = _g
                start, end = _s, idx
            if _g < 0:
                _g = 0
                _s = idx + 1
        return start
