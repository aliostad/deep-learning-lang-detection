#include "Decoration.h"
#include <glm\gtc\matrix_transform.hpp>
#include "ShapeGenerator.h"
#include "ShapeData.h"

Model * Decoration::model = nullptr;

void Decoration::initialize()
{
	model = new Model[3];
	model[0] = Model( Neumont::ShapeGenerator::makeTeapot( 10, glm::mat4() ) );
	//model[1] = Model( Neumont::ShapeGenerator::makeTorus( 10 ) );
	//model[2] = Model( Neumont::ShapeGenerator::makeSphere( 10 ) );
	model[1] = Model( Neumont::ShapeGenerator::makeCube() );
	//model[4] = Model( Neumont::ShapeGenerator::makeArrow() );
	model[2] = Model( Neumont::ShapeGenerator::makePlane( 2 ) );
}

void Decoration::draw( GLuint shader )
{
	GLuint loc = glGetUniformLocation(shader, "world");
	if (loc != -1)
	{
		glm::mat4 transform = glm::translate( glm::mat4(), position+glm::vec3(0,1,0) );

		glUniformMatrix4fv( loc, 1, false, (float*)&transform );
	}

	model[index].draw();
}