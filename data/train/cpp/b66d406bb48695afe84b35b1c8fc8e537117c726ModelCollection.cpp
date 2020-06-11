#include "ModelCollection.h"


ModelCollection::ModelCollection(string f)
{
	fileName=f;
	
}

ModelCollection::ModelCollection(void)
{
}

ModelCollection::~ModelCollection(void)
{
}

bool ModelCollection::ParseModelData()
{
	int modelCount=0;
	int currentVertex;
	ifstream modelFile;
	modelFile.open(fileName+".txt");
	string line;
	char buffer[100];

	while(modelFile)
	{
		modelFile.getline(buffer,100);
		line=buffer;

		if(buffer[0]=='v')
		{
			/*modelFile >> model.m_model[currentVertex].x >> model.m_model[currentVertex].y >> model.m_model[currentVertex].z;
			modelFile >> model.m_model[currentVertex].tu >> model.m_model[currentVertex].tv;
			modelFile >> model.m_model[currentVertex].nx >> model.m_model[currentVertex].ny >> model.m_model[currentVertex].nz;*/
			float f[8];
			int start=2;
			int end=start;

			for(int i=0;i<8;i++)
			{
				while((buffer[end]!=' ' ) && ( end<line.length()))
				{
					end++;
				}
				f[i]=stof(line.substr(start,end-start));
				
				start=end+1;
				end=start+1;
			}
			model->m_model[currentVertex].x=f[0];
			model->m_model[currentVertex].y=f[1];
			model->m_model[currentVertex].z=f[2];
			model->m_model[currentVertex].tu=f[3];
			model->m_model[currentVertex].tv=f[4];
			model->m_model[currentVertex].nx=f[5];
			model->m_model[currentVertex].ny=f[6];
			model->m_model[currentVertex].nz=f[7];
			currentVertex++;
		}

		if(buffer[0]=='c')
		{
			int start=6;
			int end=start;
			while(buffer[end]!=' ')
			{
				end++;
			}
			end++;
			int vertexCount=stoi(line.substr(start,end-start));
			model->setNumVerts(vertexCount);
		}

		if(buffer[0]=='M')
		{

		}

		if(buffer[0]=='T')
		{
			int start=3;
			int end=start;
			while(buffer[end]!=' ')
			{
				end++;
			}
			end++;
			model->textureName=line.substr(start,end-start);
			model->setTexture();  // say model has a colour map
		}

			
		if((buffer[0]=='D') && (buffer[1]=='i'))
		{
			int start=3;
			int end=start;
			float f[3];
			for(int i=0;i<3;i++)
			{
				while((buffer[end]!=' ' ) && ( end<line.length()))
				{
					end++;
				}
				f[i]=stof(line.substr(start,end-start));
				
				start=end+1;
				end=start+1;
			}

			model->setDiffuseColor(f[0],f[1],f[2]);

		}

		if(buffer[0]=='A')
		{
			int start=3;
			int end=start;
			float f[3];
			for(int i=0;i<3;i++)
			{
				while((buffer[end]!=' ' ) && ( end<line.length()))
				{
					end++;
				}
				f[i]=stof(line.substr(start,end-start));
				
				start=end+1;
				end=start+1;
			}

			model->setAmbientColor(f[0],f[1],f[2]);

		}

		if((buffer[0]=='D') && (buffer[1]=='s'))   // displacement - normal map
		{
			int start=3;
			int end=start;
			while(buffer[end]!=' ')
			{
				end++;
			}
			end++;
			model->textureName2=line.substr(start,end-start);
			model->setDisplacement();     // say model has a normal map
		}

		if(buffer[0]=='S')
		{
			int start=3;
			int end=start;
			float f[3];
			for(int i=0;i<3;i++)
			{
				while((buffer[end]!=' ' ) && ( end<line.length()))
				{
					end++;
				}
				f[i]=stof(line.substr(start,end-start));
				
				start=end+1;
				end=start+1;
			}

			model->setSpecularColor(f[0],f[1],f[2]);
		}

		if(buffer[0]=='O')
		{

		}

		if(buffer[0]=='o')
		{
			if(modelCount>0)
			{
				//model->textureName2="spotsN.dds";
				modelMeshes.push_back(model);
				
			}


			int start=2;
			int end=start;
			while(buffer[end]!=' ')
			{
				end++;
			}
			end++;
			string mName=line.substr(start,end-start);
			model=new Model(mName);
			
			currentVertex=0;
			modelCount++;
		}
	}
	//model->textureName2="spotsN.dds";
	modelMeshes.push_back(model);

	return true;
}
