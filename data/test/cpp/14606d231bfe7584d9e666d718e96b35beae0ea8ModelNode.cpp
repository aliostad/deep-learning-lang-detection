#include "ModelNode.h"
#include "Utils.h"
#include "Scene.h"
#include <string>

using namespace std;

namespace Wrench
{
	ModelNode::ModelNode()
		: Node()
	{

	};

	ModelNode::ModelNode(Scene *nScene, Model *nModel)
		: Node(nScene)
	{
		model = nModel;
	};

	ModelNode::ModelNode(Scene *nScene, const Transform &nTransform, Model *nModel)
		: Node(nScene, nTransform)
	{
		model = nModel;
	};

	ModelNode::ModelNode(Scene *nScene, const Vector3 &nPosition, const Vector3 &nOrientation, const Vector3 &nScale, Model *nModel)
		: Node(nScene, nPosition, nOrientation, nScale)
	{
		model = nModel;
	};

	ModelNode::ModelNode(Scene *nScene, const Vector3 &nPosition, const Vector3 &nOrientation, float nScale, Model *nModel)
		: Node(nScene, nPosition, nOrientation, nScale)
	{
		model = nModel;
	};

	ModelNode::ModelNode(Scene *nScene, TiXmlElement *entry)
		: Node(nScene, entry)
	{
		XmlLoop(entry, it)
		{
			string valueStr = it->ValueStr();

			if (!valueStr.compare("Model"))
			{
				if (scene)
					model = scene->content->GetModel(it->GetText());
			}
		}
	};

	ModelNode::ModelNode(Scene *nScene, TiXmlElement *entry, Model *nModel)
		: Node(nScene, entry)
	{
		model = nModel;
	};

	void ModelNode::Render(const Matrix &worldMatrix)
	{
		Matrix m = transform.GetMatrix() * worldMatrix;

		if (model)
			model->Render(m);
		Node::Render(m);
	};

	void ModelNode::Update(unsigned int Delta)
	{
		Node::Update(Delta);
	};

	BoundingBox ModelNode::GetBounds()
	{
		if (model == NULL)
			return BoundingBox(transform.Position(), transform.Position());
		return (model->Bounds() * transform.Scale()) + transform.Position();
	}
}