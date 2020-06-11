#include <vector>
#include <stack>
using namespace std; 

class Solution {
public:
	bool isValidSerialization(string preorder) {
		int start = 0, end = 0;
		vector<string> repo;
		do
		{
			end = preorder.find(',', start);
			repo.push_back(preorder.substr(start, end - start));
			start = end + 1;
		} while (end != string::npos);

		int e = 1;
		for (int i = 0; i < repo.size(); i++)
		{
			e--;
			if (e < 0)
			{
				return false;
			}
			if (repo[i] != "#")
			{
				e += 2;
			}
		}
		return e == 0;

	}
};

int main()
{
	string str = "9,3,4,#,#,1,#,#,2,#,6,#,#";
	Solution s;
	s.isValidSerialization(str);
}