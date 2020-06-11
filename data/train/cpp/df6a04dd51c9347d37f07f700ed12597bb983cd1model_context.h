#ifndef MODEL_CONTEXT_H
#define MODEL_CONTEXT_H


/*Included headers*/
/*---------------------------------------------*/
#include "model.h"
#include "glm.h"
/*---------------------------------------------*/

/*Included dependencies*/
/*---------------------------------------------*/
#include <GL/glew.h>
/*---------------------------------------------*/

/*Header content*/
/*=============================================*/

struct Model_context{
		Model_ptr model;
		glm::mat4 model_matrix;
		std::string model_context_name;
		glm::vec4 color_coeff;

		GLboolean complete;

		Model_context();
		bool load_model(Resource_manager& init_manager, const std::string& model_name);
		bool load_model(Resource_manager& init_manager, 
						const std::string& model_name, 
						const glm::vec4& color, 
						const glm::vec4& color_coeff, 
						GLfloat gloss);
};
/*=============================================*/

#endif