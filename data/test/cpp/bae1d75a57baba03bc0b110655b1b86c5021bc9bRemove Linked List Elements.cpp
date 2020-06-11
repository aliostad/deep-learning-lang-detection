/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
public:
    ListNode* removeElements(ListNode* head, int val) {
        ListNode* dump = new ListNode(-1);
        ListNode* save = dump;
        dump->next = head;
        while(dump->next != NULL) {
            if(dump->next->val == val) {
                dump->next = dump->next->next;
            }
            else {
                dump = dump->next;
            }
        }
        return save->next;
    }
};
