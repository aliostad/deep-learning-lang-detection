#include <iostream>
#include <string>
#include <cstdlib>
#include <vector>
#include "utilities.hpp"
#include "program_options.hpp"

int main(int argc,  char** argv) {

	Program_Options program_options(argc, argv);

	//the two things a user will be able to output with this program
	std::string author;
	std::string repo;

	//get the url which contains both the author/organization as well as the repo name
	auto str = exec("git config --get remote.origin.url");

	//parse that url to get the author/organization name and repo name seperate
	bool add_to_first = true;
	if (!str.empty()) {
		str.erase(0, 15);
		for (auto const& it: str) {
			if (it == '/') {add_to_first = false;}
			else{
				if (add_to_first) {author += it;}
				else              {repo += it;}
			}
		}

		repo = repo.substr(0, repo.size()-4);
	}

	//output what the user wants based on the command line
	if (program_options.Author() && program_options.Repo()) {
		std::cout << author <<  " - " << repo;
	}
	else if (program_options.Author()) {
		std::cout << author;
	}
	else if (program_options.Repo()) {
		std::cout << repo;
	}

	return EXIT_SUCCESS;
}
