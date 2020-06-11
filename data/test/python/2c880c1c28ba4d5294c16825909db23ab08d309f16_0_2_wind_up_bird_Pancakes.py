import Queue

def flipped(stack):
    result=[]
    for i in stack:
        if i=="-":
            result.append("+")
        else:
            result.append("-")
    return result

input=raw_input()
for casenumber in xrange(1,int(input)+1):
    n=list(raw_input())
    ways=[]
    frontier=Queue.PriorityQueue()
    height=len(n)
    explored=[]
    if len(n)==n.count("+"):
        ways.append(0)
    top=n[0]
    stacklen=1
    for i in range(0,height):
        if n[i]==n[0]:
            stacklen=i+1
        else:
            break
    #print stacklen
    flip=flipped(n[0:stacklen])
    #print flip
    save=flip[::-1]+n[stacklen:]
    if len(save)==save.count("+"):
        ways.append(1)
    else:
        frontier.put((save,1))
    while frontier.qsize()>0:
        start,cost=frontier.get()
        for i in range(0,height):
            if save[i]==save[0]:
                stacklen=i+1
            else:
                break
        flip=flipped(start[0:stacklen])
        save=flip[::-1]+start[stacklen:]
        #print "start",start
        #print "flip",flip
        #print "save",save,cost+1
        if len(save)==save.count("+"):
            ways.append(cost+1)
        else:
            if save not in explored:
                explored.append(save)
                frontier.put((save,cost+1))
    #print ways
    print "Case #"+str(casenumber)+": "+str(min(ways))
    
