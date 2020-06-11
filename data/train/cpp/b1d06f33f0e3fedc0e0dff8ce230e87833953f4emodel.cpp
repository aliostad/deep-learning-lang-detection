/*************************************************************************
	> File Name: model.cpp
	> Author: lw
	> Mail: 1243925457@qq.com
	> Created Time: 2015年06月06日 星期六 13时12分15秒
 ************************************************************************/

#include"model.h"

Model::Model(std::string filename)
{
    if(this->t_model.loadFromFile(filename)){
        this->s_model.setTexture(t_model);
    }
}

void Model::set_model(std::string filename)
{
    if(this->t_model.loadFromFile(filename)){}
}
