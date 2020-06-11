/* 
 * File:   Light.cpp
 * Author: brady
 * 
 * Created on February 8, 2011, 11:19 AM
 */

#include "Light.h"


Light::Light() {
    Color = Vector3D(1.0, 1.0, 1.0);
    Origin = Vector3D(0.0, 0.0, 0.0);
    Size = 1.0;
}

Light::Light(Vector3D origin, Vector3D color)
{
    Color = Vector3D(color);
    Origin = Vector3D(origin);
    Size = 1.0;
}

Light::~Light() {
}

Vector3D Light::GetRandomPoint(Ray& sampleRay, int spp)
{
    //build a basis facing the incoming light


    Vector3D Gaze, U, V, W;
    Gaze = sampleRay.GetOrigin() - Origin;
    Gaze.normalize();
    Vector3D up = Vector3D(0.0, 1.0, 0.0);
    W = Gaze * -1.0;
    U = up.cross(W);
    U.normalize();
    V = W.cross(U);
    V.normalize();


    double left, right, top, bottom;
    left = -Size/2;
    right = Size/2;
    top = -Size/2;
    bottom = Size/2;
    double xOff, yOff;
    double sampleXOffset, sampleYOffset;
    int sampleNum = sampleRay.sNum;
    int sampleColumn;
    int sampleRow;
    int sampleRows = sqrt(spp);
    int sampleCols = sampleRows;




    double theta;
    double radius;
    if(sampleNum < 0)
    {
        theta = M_PI/2.0*abs(sampleNum); //4 samples, pi/2, pi, 3*pi/2, 2pi
        radius = ((double)random()/(double)RAND_MAX)*Size*(.25);
        radius += Size*.75;
       
        xOff = cos(theta)*radius;
        yOff = sin(theta)*radius;
    }
    else
    {
        //divide theta by spp


        theta = ((2.0*M_PI)/spp) * sampleNum;
        radius = ((double)random()/(double)RAND_MAX)*Size*.75;
        radius += Size*.25;
        xOff = cos(theta)*radius;
        yOff = sin(theta)*radius;
    }

    /*
    if(sampleNum < 0)
    {
        
        sampleXOffset = (sampleNum % 2 == 0)? 0.0 : 1.0;
        sampleYOffset = (sampleNum <= -3)? 0.0 : 1.0;
        sampleColumn = sampleXOffset*(sampleCols -1);
        sampleRow = sampleYOffset*(sampleRows -1);
        if(sampleNum == -5)
        {
            sampleXOffset = 0.5;
            sampleYOffset = 0.5;
            sampleRow = sampleRows/2 - 1;
            sampleColumn = sampleCols/2 -1;
        }
        
        xOff = left + Size*((sampleColumn + sampleXOffset)/sampleCols);
        yOff = top + Size*((sampleRow + sampleYOffset)/sampleRows);
    }
    else{
        double rMult = ((double)random()/(double)RAND_MAX);
        sampleXOffset = (1.0/(sampleCols))*rMult;
        rMult = ((double)random()/(double)RAND_MAX);
        sampleYOffset = (1.0/(sampleRows))*rMult;

        sampleColumn = sampleNum % sampleCols;
        sampleRow = sampleNum / sampleRows;


        sampleXOffset += (double)sampleColumn/(double)sampleCols;
        sampleYOffset += (double)sampleRow/(double)sampleRows;


        xOff = left + Size*((sampleColumn + sampleXOffset)/sampleCols);
        yOff = top + Size*((sampleRow + sampleYOffset)/sampleRows);
    }
    */

    Vector3D rPoint;
    rPoint = Origin +U*xOff + V*yOff;
    return rPoint;

//    double q, f;
//    double u, v;
//    u = ((double)random()/(double)RAND_MAX);
//    v = ((double)random()/(double)RAND_MAX);
//
//    q = 2.0*M_PI*u;
//    f = acos(2.0*v-1.0);
//    double px = Radius*cos(q)*sin(f);
//    double py = Radius*sin(q)*sin(f);
//    double pz = Radius*cos(f);
//    return Vector3D(Origin[0]+px, Origin[1]+py, Origin[2]+pz);

//    double xRand = ((double)random()/(double)RAND_MAX *2.0 - 1.0) * Radius;
//    double yRand = ((double)random()/(double)RAND_MAX *2.0 - 1.0) * Radius;
//    double zRand = ((double)random()/(double)RAND_MAX *2.0 - 1.0) * Radius;
//    return Vector3D(Origin[0]+xRand, Origin[1]+yRand, Origin[2]+zRand);
}
