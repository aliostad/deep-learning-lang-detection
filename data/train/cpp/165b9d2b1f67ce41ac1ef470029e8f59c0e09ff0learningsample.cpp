#include "learningsample.h"

// Constructors
LearningSample::LearningSample()
{
    _inputList = 0 ;
    _objectiveList = 0 ;
}

LearningSample::LearningSample(QList<double> input, QList<double> objective)
{
    _inputList = new QList<double> (input) ;
    _objectiveList = new QList<double> (objective) ;
}

LearningSample::LearningSample(const LearningSample &sample)
{
    if (sample._inputList != 0)
    {
        _inputList = new QList<double> (*sample._inputList) ;
    }
    else
    {
        _inputList = 0 ;
    }

    if (sample._objectiveList != 0)
    {
        _objectiveList = new QList<double> (*sample._objectiveList) ;
    }
    else
    {
        _objectiveList = 0 ;
    }
}
