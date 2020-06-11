#include "Profiler.hpp"
#include <iostream>

void Profiler::BeginSample(const std::string & sampleName)
{
#ifdef _DEBUG
	if (sampleName != "")
	{
		Sample sample(sampleName);
		m_sampleStack.push_back(sample);
	}
	else
	{
		std::cerr << "Profiler Error: Sample name cannot be an empty string!" << '\n';
	}
#endif
}

void Profiler::EndSample()
{
#ifdef _DEBUG
	if (m_sampleStack.size() != 0)
	{
		//Get the sample at the top of the stack
		const Sample& sample = GetTopMostSample();

		//Store the sample data in a table
		m_sampleData[sample.GetName()] = sample.GetElapsedTime();
		
		//Retrieve the current data in the sample string
		const std::string currentString = GetAllSampleDataAsString();

		//Clear the string stream
		m_sampleDataStringStream.str(std::string());

		//Add the sample data into a formatted string, starting with the first inner element
		for (size_t tabs = 1; tabs < m_sampleStack.size(); ++tabs)
		{
			m_sampleDataStringStream << '\t';
		}
		m_sampleDataStringStream << sample.GetName() << ": " << sample.GetElapsedTime() << "s" << '\n';

		//Add the current data string after this sample data string, reversing the order of the samples, putting the outermost samples at the start of the string
		m_sampleDataStringStream << currentString;

		//Pop the sample from the stack
		m_sampleStack.pop_back();
	}
#endif
}

void Profiler::Clear()
{
#ifdef _DEBUG
	//Clear the stack
	m_sampleStack.clear();

	//Clear the data table
	m_sampleData.clear();

	//Clear the data string
	m_sampleDataStringStream.str(std::string());
#endif
}

float Profiler::GetSampleData(const std::string & sampleName)
{
#ifdef _DEBUG
	auto sampleDataItr = m_sampleData.find(sampleName);

	if (sampleDataItr != m_sampleData.end())
	{
		return sampleDataItr->second;
	}
	else
	{
		return 0.0f;
	}
#else
	return 0.0f;
#endif
}

std::string Profiler::GetAllSampleDataAsString()
{
#ifdef _DEBUG
	return m_sampleDataStringStream.str();
#else
	return "";
#endif
}

const Sample & Profiler::GetTopMostSample()
{
	return m_sampleStack[m_sampleStack.size() - 1];
}
