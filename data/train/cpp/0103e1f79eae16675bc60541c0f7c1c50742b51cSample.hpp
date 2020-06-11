/*********************************************************************************************//*!
*
*  @file        Sample.hpp
*
*  @author      Peter Goldsborough
*
*  @date        27/09/2014
*
*  @brief       Sample structure.
*
*  @details     This file defines structs for holding two-channel samples.
*
*************************************************************************************************/

#ifndef __Anthem__Sample__
#define __Anthem__Sample__

/*************************************************************************************************//*!
*
*  @brief       Struct holding two double values for stereo audio.
*
*  @details     Multiplication, dvision, additon and subtraction between Samples all possible.
*
*****************************************************************************************************/

struct Sample
{
    Sample(double val = 0)
    : left(val), right(val)
    { }
    
    Sample(double lf, double ri)
    : left(lf), right(ri)
    { }
    
    Sample(const Sample& other)
    {
        if (&other != this)
        {
            this->left = other.left;
            this->right = other.right;
        }
    }
    
    Sample& operator= (const Sample& other)
    {
        if (this != &other)
        {
            left = other.left;
            right = other.right;
        }
        
        return *this;
    }
    
    Sample& operator*= (const Sample& other)
    {
        left *= other.left;
        right *= other.right;
        
        return *this;
    }
    
    Sample operator* (const Sample& other)
    {
        Sample ret(*this);
        
        ret.left *= other.left;
        
        ret.right *= other.right;
        
        return ret;
    }
    
    Sample& operator/= (const Sample& other)
    {
        left /= other.left;
        right /= other.right;
        
        return *this;
    }
    
    Sample operator/ (const Sample& other)
    {
        Sample ret(*this);
        
        ret.left /= other.left;
        
        ret.right /= other.right;
        
        return ret;
    }
    
    Sample& operator += (const Sample& other)
    {
        left += other.left;
        right += other.right;
        
        return *this;
    }
    
    Sample operator+ (const Sample& other)
    {
        Sample ret(*this);
        
        ret.left += other.left;
        ret.right += other.right;
        
        return ret;
    }
    
    Sample& operator -= (const Sample& other)
    {
        left -= other.left;
        right -= other.right;
        
        return *this;
    }
    
    Sample operator- (const Sample& other)
    {
        Sample ret(*this);
        
        ret.left -= other.left;
        
        ret.right -= other.right;
        
        return ret;
    }
    
    double left;
    double right;
};

#endif /* defined(__Anthem__Sample__) */
