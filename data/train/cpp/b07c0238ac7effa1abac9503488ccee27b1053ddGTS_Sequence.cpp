

Sequence::Sequence()
{
	//ctor
}

Sequence::~Sequence()
{
	std::list<GTS::Instruction*>::iterator nLocator;
	for(nLocator = m_instructions_.begin(); nLocator != m_instructions_.end(); ++nLocator)
	{
		if(nLocator != NULL)
		{
			delete nLocator;
		}
	}
}


int Sequence::set_child(GTS::Instruction* child)
{
	if(child == NULL)
	{
		printf("Can't add child to sequence. Child is null pointer.\n");
		return -1;
	}
	std::list<GTS::Instruction*>::iterator nLocator;
	for(nLocator = m_instructions_.begin(); nLocator != m_instructions_.end(); ++nLocator)
	{
		if(nLocator == child)
		{
			printf("Can't add new child to sequence, element already on the list.\n");
			return -1;
		}
	}
	m_instructions_.push_back(child);

	nLocator = m_instructions_.begin();

	return 0;
}
int Sequence::process()
{
	if(nLocator == NULL)
	{
		printf("Wrong AI construction. Sequence contains null pointer.\n");
		return -1;
	}

	return nLocator->process();
}
