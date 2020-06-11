#include <string>
#include <assert.h>
using namespace std;

struct NodeChunk {
    string * val;
    NodeChunk * next;
};

struct Stack {
    int chunkSize;
    int topElt;
    NodeChunk *firstChunk;
};

NodeChunk *createNewNodeChunk(int N) {
    assert(N > 0);
    NodeChunk *chunk = new NodeChunk;
    chunk->next = NULL;
    chunk->val = new string[N];
    return chunk;
}

void initStack(int chunkSize, Stack& s) {
    s.chunkSize = chunkSize;
    s.topElt = chunkSize - 1;
    s.firstChunk = NULL;
}

bool isEmpty(Stack s) {
    return s.firstChunk == NULL;
}

void push(string val, Stack& s) {
    s.topElt++;
    if (s.topElt == s.chunkSize) {
        NodeChunk *chunk = createNewNodeChunk(s.chunkSize);
        chunk->val[0] = val;
        chunk->next = s.firstChunk;
        s.firstChunk = chunk;
        s.topElt = 0;
    } else s.firstChunk->val[s.topElt] = val;
}

void pop(Stack& s) {
    assert(!isEmpty(s));

    s.topElt--;
    if (s.topElt == -1) {
        NodeChunk *chunk = s.firstChunk;
        s.firstChunk = s.firstChunk->next;
        s.topElt = s.chunkSize - 1;
        delete[] chunk->val;
        delete chunk;
    } else s.firstChunk->val[s.topElt + 1] = "";
}

string top(const Stack& s) {
    assert(!isEmpty(s));

    return s.firstChunk->val[s.topElt];
}

int size(const Stack& s) {
    if (isEmpty(s)) return 0;

    NodeChunk *node = s.firstChunk;
    int count = 0;
    while (node && node->next) {
        node = node->next;
        count += s.chunkSize;
    }

    return count + s.topElt + 1;
}

void swap(Stack& s) {
    assert(size(s) > 1);

    string first = top(s);
    pop(s);
    string second = top(s);
    pop(s);
    push(first, s);
    push(second, s);
}

int main() { return 0; }