#include <string>
#include <unordered_map>
#include <unordered_set>

using namespace std;


class Solution {
public:
	string removeDuplicateLetters(string s) {
		unordered_map<char, int> table;
		for (int i = 0; i < s.size(); i++)
		{
			if (table.find(s[i]) != table.end())
			{
				table[s[i]]++;
			}
			else
			{
				table[s[i]] = 1;
			}
		}

		string result;
		unordered_set<char> repo;
		for (char& c : s)
		{
			table[c]--;
			if (repo.find(c) != repo.end())
			{
				continue;
			}
			while (!result.empty() && result.back() > c && table[result.back()] > 0)
			{
				repo.erase(result.back());
				result.pop_back();

			}
			result.push_back(c);
			repo.insert(c);
		}
		return result;

	}
};


int main()
{
	Solution s;
	s.removeDuplicateLetters("cbacdcbc");
}