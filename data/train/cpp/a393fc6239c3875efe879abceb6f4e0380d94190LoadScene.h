//
//  LoadScene.h
//  Grow1
//
//  Created by Mikel on 19/05/13.
//
//

#ifndef __Grow1__LoadScene__
#define __Grow1__LoadScene__


void setLoadSceneAndStart(CCDirector *director);



class LoadScene : public cocos2d::CCScene {
    
public:
    LoadScene();
    ~LoadScene();
    bool init();
    static LoadScene *create();
    
    void loadGameContent();
    
    void exitLoadScene();
    
    //CCLayerGradient *fondo;
    CCLabelTTF *texto;
    
    
    
};





extern LoadScene *theLoadScene;



#endif /* defined(__Grow1__MenuScene__) */
