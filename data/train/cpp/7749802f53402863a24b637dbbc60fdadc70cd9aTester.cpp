#include "stdafx.h"
#include "Tester.h"


Tester::Tester()
{
}

void Tester::Test1(GraphManager manager)
{
	RawSample sample;
	sample.EventId = 0;
	sample.Label = 1;
	manager.AddSample(sample);
	
	sample.EventId = 1;
	manager.AddSample(sample);

	sample.EventId = 2;
	manager.AddSample(sample);

	sample.EventId = 3;
	manager.AddSample(sample);

	sample.EventId = 4;
	manager.AddSample(sample);

	sample.EventId = 5;
	sample.Label = 0;
	manager.AddSample(sample);

	EdgeElement edge;
	edge.First = 0;
	edge.Second = 5;
	manager.AddEdge(edge);

	edge.First = 1;
	edge.Second = 5;
	manager.AddEdge(edge);

	edge.First = 2;
	edge.Second = 5;
	manager.AddEdge(edge);

	edge.First = 3;
	edge.Second = 5;
	manager.AddEdge(edge);

	edge.First = 4;
	edge.Second = 5;
	manager.AddEdge(edge);
	manager.FixLastEdge();
	manager.VertexCover();
	std::vector<RawSample> final;
	manager.Extract(final);
	
	//This should have 4 signals

	int signals = 0;
	for (auto sample : final)
	{
		if (sample.Label == 1)
			signals++;
	}

	if (signals == 4)
		std::cout << "Test passed\n";
	else
		std::cout << "Test failed at " << __FILE__ << std::endl;

}


Tester::~Tester()
{
}
