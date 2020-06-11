#pragma once
#include "vividgl.h"

#include "Model.h"

namespace vivid
{
	class ModelMgr
	{
	public:
		ModelMgr ();
		~ModelMgr ();
		CTOR_NMOV_NCPY (ModelMgr);
	public:
		bool Initialize ();
		void Shutdown ();

	public:
		/// <summary>
		/// Create a new unconfigured model.
		/// </summary>
		ModelHandle Create ();
		/// <summary>
		/// Delete the specified model.
		/// </summary>
		void Delete (const ModelHandle& model);

		/// <summary>
		/// Validate if the handle 'model' references a valid model object.
		/// </summary>
		bool Validate (const ModelHandle& model);
		/// <summary>
		/// Retreive the model for the specified handle.
		/// </summary>
		Model& Get (const ModelHandle& model);

	private:
		DynArray<Model, GenHandle<ModelHandle>>	models;
	};
}