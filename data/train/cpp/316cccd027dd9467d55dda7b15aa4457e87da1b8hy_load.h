#ifndef HY_LOAD_H_INCLUDED
#define HY_LOAD_H_INCLUDED

#include "hy_make.h"

#include "thing.h"
#include "context.h"

struct As{} as;

struct Load_path_as_X{
    string m_path;
    Load_path_as_X(string path) : m_path{path} {}
    void operator-(string name){
        Thing new_one;
        new_one.LoadPicture(m_path);
        new_one.Update(0.0f);
        context::add_thing(name, new_one);
        it = name;
    }
};

struct Load_path_X{
    string m_path;
    Load_path_X(string path) : m_path {path} {}
    Load_path_as_X operator-(As as){
        return Load_path_as_X(m_path);
    }
};

struct Load_X{
    Load_path_X operator-(string X){
        return Load_path_X(X);
    }
} load;

#endif // HY_LOAD_H_INCLUDED
