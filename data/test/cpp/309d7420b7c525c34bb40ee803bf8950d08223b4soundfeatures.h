#ifndef SOUNDFEATURES_H_
#define SOUNDFEATURES_H_

class Peak
{
private:
    unsigned int m_PeakSampleIndex;
    unsigned int m_AttackSampleIndex;

public:
    Peak(unsigned int peakSampleIndex, unsigned int attackSampleIndex) 
        : m_PeakSampleIndex(peakSampleIndex), m_AttackSampleIndex(attackSampleIndex)
    {}    
    
	void OffsetBy(unsigned int offset)
	{
		m_PeakSampleIndex	+= offset;
		m_AttackSampleIndex += offset;
	}

	struct OffsetByFunctor
	{
		unsigned int m_Offset;

		OffsetByFunctor(unsigned int offset) : m_Offset(offset) {}
		
		void operator()(Peak& peak)
		{
			peak.OffsetBy(m_Offset);
		}
	};

	void SetPeakSampleIndex(unsigned int peakSampleIndex) { m_PeakSampleIndex = peakSampleIndex; }
	void SetAttackSampleIndex(unsigned int attackSampleIndex) { m_AttackSampleIndex = attackSampleIndex; }

    unsigned int GetPeakSampleIndex() const { return m_PeakSampleIndex; }
    unsigned int GetAttackSampleIndex() const { return m_AttackSampleIndex; }
};

#endif // SOUNDFEATURES_H_