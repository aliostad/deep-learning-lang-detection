#/usr/bin/python
import sys
def mixupstep(conffile,savepath):
    conf=open(conffile);
    for line in conf.readlines():
        save=open('%s/mixupstep%d.hed'%(savepath,int(line)),'w');
#        if int(line)==1:
#            save.write('MU %d {w.state[2].mix}\n'%(int(line)*2));
#        else :
#            save.write('MU %d {*.state[2].mix}\n'%(int(line)));
#            save.write('MU %d {w.state[2].mix}\n'%(int(line)*2));
        save.write('MU %d {*.state[2].mix}\n'%(int(line)*2));
        save.close();
    conf.close();

if __name__=='__main__':
    mixupstep(sys.argv[1],sys.argv[2]);