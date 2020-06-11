/*
 * =====================================================================================
 *
 *       Filename:  testReadModel.cpp
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2014/7/26 9:51:01
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *   Organization:  
 *
 * =====================================================================================
 */

#include <iostream>
#include <cstdio>
using namespace std;

struct Point
{
    int x;
    int y;
};

////////////////////////////////////////////////////////////////////
//
//  全局变量
//
////////////////////////////////////////////////////////////////////
Point modelSize;
char **model;



// 文件第一行会记录模型的高度，模型的宽度
void readModelFromFile( const char *filename )
{
    FILE *fp;
    fp  = fopen( filename, "r" );

    if( !fp )
    {
        printf( "%s打开出错！\n", filename );
        return;
    }

    modelSize.y = 0;
    modelSize.x = 0;
    fscanf( fp, "%d %d", &modelSize.x, &modelSize.y );
    model = new char *[modelSize.y];

    char temp[10];
    fgets( temp, 10, fp );

    int i = 0;
    while( !feof( fp ) )
    {
        model[i] = new char[ modelSize.x ];
        // 由于temp中会把换行符也读取进来
        fgets( model[i], 1024, fp );
        model[i][modelSize.x-2] = '\0';

        ++i;
    }

    fclose( fp );
}

void destoryModel()
{
    if( model )
    {
        for( int i = 0; i < modelSize.y; ++i )
        {
            delete[] model[i];
        }
        delete[] model;
    }
}


int main(void)
{
    readModelFromFile( "testModel.txt" );
    for( int i = 0; i < modelSize.y; ++i )
    {
        cout << model[i] << endl;
    }

    destoryModel();

    return 0;
}
