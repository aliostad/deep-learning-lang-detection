#ifndef TEXTURE_HPP
#define TEXTURE_HPP

// Load a .BMP file using our custom loader
GLuint loadBMP_custom(const std::string &imagepath);

//// Since GLFW 3, glfwLoadTexture2D() has been removed. You have to use another texture loading library, 
//// or do it yourself (just like loadBMP_custom and loadDDS)
//// Load a .TGA file using GLFW's own loader
//GLuint loadTGA_glfw(const std::string &imagepath);

// Load a .DDS file using GLFW's own loader
GLuint loadDDS(const std::string &imagepath);


#endif
