#pragma once;

#include "pocketsphinx.h"

using namespace System;
using namespace System::Runtime::InteropServices;
namespace PocketSphinxNet
{
	public ref class NGramModel
	{
	internal:

		ngram_model_t* model;

	public:

		NGramModel()
		{
			this->model = 0;
		}
		~NGramModel()
		{
			this->Free();
		}

	internal:

		NGramModel(ngram_model_t* model)
		{
			this->model = model;
		}
		operator ngram_model_t* ()
		{
			return this->model;
		}

	public:


		bool Free()
		{
			bool done = true;
			if(this->model !=0)
			{
				done = ngram_model_free(this->model) == 0;
				if(done)
				{
					this->model = 0;
				}
			}
			return done;
		}


	};
}