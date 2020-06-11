#include <algorithm>
#include <string>
#include <vector>
#include <stack>
#include <unordered_set>
#include <unordered_map>
#include <iostream>
using namespace std;


class Solution {
public:
	bool isValid(string s) {
		unordered_map<char, char> table =
		{ { '(', ')' },
		{ '{', '}' },
		{ '[', ']' }
		};
		stack<char> repo;
		for (int i = 0; i < s.length(); i++)
		{
			if (table.find(s[i]) != table.end())
			{
				repo.push(s[i]);
			}
			else if (repo.empty() || table[repo.top()] != s[i])
			{
				return false;
			}
			else
			{
				repo.pop();
			}
		}

		return repo.size() == 0;
	}
};