//
//  Chunk.cpp
//  NYUCodebase
//
//  Created by Max Lebedev on 12/2/15.
//  Copyright © 2015 Ivan Safrin. All rights reserved.
//

#include "Chunk.hpp"

#define TILE_X 0.17f
#define TILE_Y 0.20f


Chunk::Chunk(){
    chunk = new int[CHUNK_W*CHUNK_H]{0};
    chunkSize = 200;
}

void Chunk::populate(int ch[CHUNK_H][CHUNK_W]){
    int k = 0;
    for (int i = 0; i < CHUNK_H; i++){
        for (int j = 0; j < CHUNK_W; j++){
            chunk[k++] = ch[j][i];
        }
    chunkSize += k;
    }
}

void Chunk::print(){
    for (int i = 0; i < chunkSize; i++){
        std::cout << chunk[i] << ' ';
        if (!(i % CHUNK_W)) {
            std::cout << '\n';
        }
    }
}

void Chunk::set(int i, int j, int val){
    chunk[(i*CHUNK_W)+j] = val;
}

int Chunk::get(int i, int j){
    return chunk[(i*CHUNK_W)+j];
}

int Chunk::sumCardNeighbors(int i, int j){
    return chunk[(i*CHUNK_W)+j-1] + chunk[(i*CHUNK_W)+j+1] + chunk[((i+1)*CHUNK_W)+j]
    + chunk[((i-1)*CHUNK_W)+j];
}


float Chunk::tileGlobalX(int i, int j){
    return (index.first * Chunk::width * TILE_X) + (j*TILE_X);
}


float Chunk::tileGlobalY(int i, int j){
    return (index.second * height * TILE_Y) + (i*TILE_Y);
}

std::pair <float,float> Chunk::toGlobalCoords(int i, int j){//This is approximate
    std::pair <float,float> coords = std::make_pair((index.first * width * TILE_X) + (j*TILE_X),(index.second * height * TILE_Y) + (i*TILE_Y));
    return coords;
}

 vector<int> Chunk::fromGlobalCoords(float x, float y){
     int chunkIndx = floor(x / (Chunk::width * TILE_X));
     int chunkIndy = 1 + floor(y / (Chunk::height * TILE_Y));
    
    
     int chunkx = fmod(x,(Chunk::width * TILE_X))/TILE_X;
     int chunky = fmod(y,(Chunk::height * TILE_Y))/TILE_Y;
     chunkx = chunkx >= 0 ? chunkx : (Chunk::width -1  + (chunkx % Chunk::width));
     chunky = chunky >= 0 ? chunky : -1*(chunky % Chunk::height);
     
     //printf("rounded:: indX: %d indy: %d tilex: %d tiley: %d \n", chunkIndx, chunkIndy, chunkx, chunky);
    
     //todo potential problem: this goes from 0-18 andnot 0-19
     vector<int> coords = {chunkIndx, chunkIndy, chunkx, chunky};
     
     return coords;
}


int Chunk::size(){
    return chunkSize;
}

