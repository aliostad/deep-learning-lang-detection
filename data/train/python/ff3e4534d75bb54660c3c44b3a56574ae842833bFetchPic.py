# creat by zz
#2013-11-9

from Lib.donwBaidu import Dac,anals
import pickle
import os



#define
Time=10
NumOfS=1
try:
    with open('url.txt',encoding='utf-8') as f:
        url=f.read().rstrip(r'/')
except FileNotFoundError:
    print('逗比，url那个文件夹是不是被干掉了，没办法，再帮你创建一个吧')
    with open('url.txt','w') as f:
        f.write('add url')
    print('press Enter')
    input()
    os._exit(0)
else: pass

#print(BaseLink)

if (os.path.exists('jpg'))==False:
    os.makedirs('jpg')
os.chdir('jpg')

#load save
if os.path.exists('save.pickle'):
    with open('save.pickle','rb') as f:
        save=pickle.load(f)
else: save={'g':0}
if save['g']!=0 and save['dir']==url:
    url=save['url']
    WantPg=save['left']
else:
    

    try:
        WantPg=max(int(input('how many pages do you want to download\n')),0)
        
    except:
        print("输入纯数字")
        input()
    else:
        pass
    



# save
if save['g']==0: save['dir']=url

save['g']=1
save['left']=WantPg

#BaseLink,GetPg=url.split(r'?')[0],int(url.split(r'=')[-1])
BaseLink=r'http://tieba.baidu.com'
if url.find(r'?')>-1:
    GetPg=int(url.split('=')[-1])
    #print(3)
else: GetPg=1

print(GetPg)


Tot=anals(url)
print(Tot)

for Pg in range(GetPg,min(Tot+1,GetPg+WantPg)):
    NextHref=Dac(url)
    if (Pg%NumOfS==0):
        save['url']=url
        save['left']-=1
        with open('save.pickle','wb') as f:
            pickle.dump(save,f)
        
    url=BaseLink+NextHref
    #print(url)
    
#   save['g']=0
#   with open('save.pickle','wb') as f:
#       pickle.dump(save,f)
if os.path.exists('save.pickle'):os.remove('save.pickle')
# del save.pickle
print('all done!')

