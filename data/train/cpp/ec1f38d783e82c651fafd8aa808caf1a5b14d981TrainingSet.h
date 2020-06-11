#pragma once

class TrainingSet
{
public:
    HIMAGELIST m_imageList;
    map<UINT, TrainingSample*> sampleMap;
    int posSampleCount, negSampleCount, motionSampleCount, rangeSampleCount;

    TrainingSet(void);
    ~TrainingSet(void);
    HIMAGELIST GetImageList();
    void AddSample(TrainingSample *sample);
	int GetOriginalSampleGroup(UINT sampleId);
    void SetSampleGroup(UINT sampleId, int groupId);
    void RemoveSample(UINT sampleId);
	void CopyTo(TrainingSet *target);
	void ClearSamples();

	void Save(WCHAR *directory);

    // debugging function that draws the samples to a window
    void ShowSamples();

private:

};
