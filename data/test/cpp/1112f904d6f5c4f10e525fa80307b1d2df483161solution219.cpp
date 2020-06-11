#include "solution219.h"

Solution219::Solution219()
{
}
bool Solution219::containsNearbyDuplicate(vector<int> &nums, int k)
{
    map<int,int> dump;
    vector<int>::iterator it;
    int len = nums.size();
    for(int i=0;i<len;++i)
    {
        if(dump.count(nums[i]))
        {
            if((i - dump[nums[i]]) <=k)
                return true;
            else
                dump[nums[i]] = i;
        }
        else
            dump.insert(make_pair(nums[i],i));
    }
    return false;
//    int idx = 0;
//    for(it = nums.begin();it != nums.end();++it,++idx)
//    {
//        if(dump.count(*it))
//        {
//            if((idx - dump[*it]) <= k)
//                return true;
//            else
//                dump[*it] = idx;
//        }
//        else
//            dump.insert(make_pair(*it,idx));
//    }
//    return false;
}
