#include <algorithm>
#include <string>
#include <vector>
#include <unordered_set>
#include <unordered_map>
#include <map>
#include <set>
#include <stack>
#include <iostream>
#include <sstream>
#include <assert.h>
using namespace std;

class Solution {
public:
	int largestRectangleArea(vector<int>& height) {
		stack<int> repo;
		height.push_back(0);
		int result = 0;
		for (int i = 0; i < height.size();)
		{
			if (repo.empty() || height[i] > height[repo.top()])
			{
				repo.push(i++);
			}
			else
			{
				int tmp = repo.top();
				repo.pop();
				result = max(result, height[tmp] * (repo.empty() ? i : i - repo.top() - 1));
			}
		}

		return result;
	}
};