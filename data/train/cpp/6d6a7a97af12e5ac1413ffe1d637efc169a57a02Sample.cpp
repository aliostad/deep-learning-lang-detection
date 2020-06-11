#include "misc/Sample.h"
#include "math.h"
#include "util/Hash.h"
#include "misc/Session.h"

using namespace std;
using namespace ntse;


/**
 * 对样本进行采样分析
 *
 * @param session  会话
 * @param object  可扫描的模块提供的扫描对象
 * @param maxSample  最大采样数目，这个包含小样本区和大样本区之和
 * @param smallScanPct  小样本区采样的比例
 * @param scanBig  是否采样大样本区
 * @param difference  多次采样时，相隔两次采样的差异度，这个值越小，对于多次平行采样的结果相似度要求越高
 * @param bScanTimes  大采样区采样分批进行的次数
 * @return  采样分析结果
 */
SampleResult * SampleAnalyse::sampleAnalyse(Session *session, Analysable *object, int maxSample, int smallScanPct,
											bool scanBig, double difference, int bScanTimes) {
	assert(maxSample > 0);
	if (!smallScanPct && !scanBig)
		return NULL; // 既不扫描小样本区，也不扫描大样本区，只有返回空了
	u64 mcsavept = session->getMemoryContext()->setSavepoint();
	assert(smallScanPct >= 0 && smallScanPct <= 100);
	uint smallSampleCnt = 0, bigSampleCnt = 0;
	Sample **sScanSamples = NULL, **bScanSamples = NULL;
	SampleID *bSIDs = NULL;
	SampleResult *smallSampleResult = NULL, *bigSampleResult = NULL;
	SampleHandle *handle;
	Sample *sample;

	if (smallScanPct) {
		/* 需要进行小样本区扫描 */
		int count = maxSample * smallScanPct / 100;
		if (count > 0) {
			sScanSamples = (Sample **)session->getMemoryContext()->alloc(count * sizeof(Sample *));//new Sample *[count];
			handle = object->beginSample(session, count, true);
			while (count-- && (sample = object->sampleNext(handle)) != NULL) {
				sScanSamples[smallSampleCnt++] = sample;
			}
			object->endSample(handle);
		}
		if (smallSampleCnt) {
			smallSampleResult = analyse(sScanSamples, smallSampleCnt);
		} else {
			scanBig = true; // 内存区没有样本，那只有外存采样了
			smallScanPct = 0;
		}
	}
	if (scanBig && !(smallScanPct == 100)) {
		/* 大样本分批采样 */
		/* 第一次采样，和小样本区结果进行比较 */
		int bSampleTotal = maxSample - smallSampleCnt; //maxSample * (100 - smallScanPct) / 100; // 总大样本区采样数
		bScanSamples = (Sample **)session->getMemoryContext()->alloc(bSampleTotal * sizeof(Sample *));//new Sample *[bSampleTotal];
		bSIDs = (SampleID *)session->getMemoryContext()->alloc(bSampleTotal * sizeof(SampleID));//new SampleID[bSampleTotal];
		Hash<SampleID, Sample *> sidHT(bSampleTotal);
		int count = bSampleTotal / bScanTimes; // 每一次采样需要的样本数
		if (0 == count) count = 1;
		handle = object->beginSample(session, count, false);
		while (count-- && (sample = object->sampleNext(handle)) != NULL) {
			if (sidHT.get(sample->m_ID)) { // 已经有该样本号的样本了，则删除老样本
				//Sample *old = sidHT.get(sample->m_ID);
				//delete old;
				sidHT.remove(sample->m_ID);
			}
			sidHT.put(sample->m_ID, sample);
			//bScanSamples[bigSampleCnt++] = sample;
		}
		object->endSample(handle);
		sidHT.elements(bSIDs, bScanSamples);
		bigSampleCnt = (uint)sidHT.getSize();
		assert(bigSampleCnt); // 不处理无法采样任何页面的情况
		bigSampleResult = analyse(bScanSamples, bigSampleCnt);
		/* 比较big结果和small结果 */
		if (!smallScanPct || !compareResult(smallSampleResult, bigSampleResult, difference)) {
			// 结果不符合，或者根本没有小样本结果，继续采样以便对比。
			count = bSampleTotal / bScanTimes; // 每次采样数目
			if (0 == count) count = 1;
			Sample **tmpSample = (Sample **)session->getMemoryContext()->alloc(count * sizeof(Sample *));//new Sample *[count];
			SampleResult *tmpResutl;
			for (int i = 1; i < bScanTimes; ++i) { // 因为已经采样过一次，所以i起始为1
				handle = object->beginSample(session, count, false);
				int samCnt = 0;
				while (samCnt < count && (sample = object->sampleNext(handle)) != NULL) {
					tmpSample[samCnt++] = sample;
				}
				object->endSample(handle);
				tmpResutl = analyse(tmpSample, samCnt);
				bool isSimilar = compareResult(tmpResutl, bigSampleResult, difference);
				for (int i = 0; i < samCnt; ++i) {
					if (sidHT.get(tmpSample[i]->m_ID)) { // 已经有该样本号的样本了，则删除老样本
						//Sample *old = sidHT.get(tmpSample[i]->m_ID);
						//delete old;
						sidHT.remove(tmpSample[i]->m_ID);
					}
					sidHT.put(tmpSample[i]->m_ID, tmpSample[i]);
					//bScanSamples[bigSampleCnt++] = tmpSample[i];
				}
				delete tmpResutl;
				delete bigSampleResult;
				sidHT.elements(bSIDs, bScanSamples);
				bigSampleCnt = (uint)sidHT.getSize();
				bigSampleResult = analyse(bScanSamples, bigSampleCnt);
				if (isSimilar) break;
			}
			//delete [] tmpSample;
		}

	}
	/* 清理sample */
	/* 使用MemoryContext不需要手动释放内存
	if (smallSampleCnt) {
		for (uint i = 0; i < smallSampleCnt; ++i) {
			delete sScanSamples[i];
		}
	}
	*/
	/*
	if (smallScanPct) {
		delete [] sScanSamples;
	}*/
	/* 使用MemoryContext不需要手动释放内存
	if (bigSampleCnt) {
		for (uint i = 0; i < bigSampleCnt; ++i) {
			delete bScanSamples[i];
		}
		delete [] bScanSamples;
		delete [] bSIDs;
	}*/
	session->getMemoryContext()->resetToSavepoint(mcsavept);
	/* 返回结果 */
	if (bigSampleCnt) {
		assert(bigSampleResult != NULL);
		if (smallSampleResult)
			delete smallSampleResult;
		return bigSampleResult;
	} else {
		assert(bigSampleResult == NULL);
		return smallSampleResult;
	}
}

/**
 * 分析样本，返回结果
 * 
 * @param samples  Sample指针数组
 * @param numSample  数组中的Sample指针个数
 */
SampleResult * SampleAnalyse::analyse(Sample **samples, int numSample) {
	long *fieldSum;		/** 各列的和 */
	double *delta2Sum;	/** 各列的均值差方和 */
	assert(numSample > 0 && samples);
	int numFields = samples[0]->getFieldNum();
	fieldSum = new long[numFields];
	delta2Sum = new double[numFields];
	SampleResult *result = new SampleResult(numFields);
	/* 计算各列和 */
	for (int fi = 0; fi < numFields; ++fi) {
		fieldSum[fi] = 0;
		for (int si = 0; si < numSample; ++si) {
			fieldSum[fi] += (*samples[si])[fi];
		}
		/* 记录列均值 */
		//(result->m_fieldCalc + fi)->m_average = (double)fieldSum[fi] / (double)numSample;
		result->m_fieldCalc[fi].m_average = (double)fieldSum[fi] / (double)numSample;
	}
	/* 计算各列方差和 */
	for (int fi = 0; fi < numFields; ++fi) {
		delta2Sum[fi] = .0;
		for (int si = 0; si < numSample; ++si) {
			double avgDiff = result->m_fieldCalc[fi].m_average - (*samples[si])[fi];
			delta2Sum[fi] += avgDiff * avgDiff;
		}
		/* 记录方差均值 */
		//(result->m_fieldCalc + fi)->m_sumVariance = delta2Sum[fi] / (double)numSample;
		result->m_fieldCalc[fi].m_delta = sqrt(delta2Sum[fi] / (double)numSample);
	}
	delete [] fieldSum;
	delete [] delta2Sum;
	result->m_numSamples = numSample;
	return result;
}

/**
 * 检查两个SampleAnalyse是否符在给定的差异度范围之内。
 *
 * @param first, second  两个采样结果
 * @param difference  相似度容许差异范围，就是两个采样结果均值差和各自方差的比例。
 * @return  在容许范围内为true，否则返回false
 */
bool SampleAnalyse::compareResult(SampleResult *first, SampleResult *second, double difference) {
	assert(first->m_numFields == second->m_numFields);
	bool isSimilar = true;
	for (int fi = 0; fi < first->m_numFields; ++fi) {
		double diff = first->m_fieldCalc[fi].m_average - second->m_fieldCalc[fi].m_average;
		if (diff < 0) diff = 0 - diff;
		if (first->m_fieldCalc[fi].m_delta * difference < diff || second->m_fieldCalc[fi].m_delta * difference < diff) {
			isSimilar = false;
			break;
		}
	}
	return isSimilar;
}


Sample * Sample::create(Session *session, int numFields, SampleID id) {
	Sample *sample = (Sample *)session->getMemoryContext()->alloc(sizeof(Sample));
	sample->m_numFields = numFields;
	sample->m_value = (int *)session->getMemoryContext()->alloc(sizeof(int) * numFields);
	for (int i = 0; i < numFields; ++i) {
		sample->m_value[i] = 0;
	}
	sample->m_ID = id;
	return sample;
}
