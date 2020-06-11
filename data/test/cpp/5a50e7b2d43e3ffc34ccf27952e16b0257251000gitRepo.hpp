/*
 * RandomGithub: gitRepo.hpp
 * Copyright (C) 2014 Kyle Givler
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

/**
 * @file gitRepo.hpp
 * @author Kyle Givler
 */

#ifndef _GITHUB_REPO_H_
#define _GITHUB_REPO_H_

class GitRepo
{
public:
  
  void setRepoId(unsigned int id) {this->id = id;}
  void setOwnerLogin(std::string in) { this->ownerLogin = in; }
  void setOwnerHtmlUrl(std::string in) { this->ownerHtmlUrl = in; }
  void setRepoName(std::string in) { this->repoName = in; }
  void setRepoFullName(std::string in) { this->repoFullName = in; }
  void setRepoHtmlUrl(std::string in) { this->repoHtmlUrl = in; }
  void setRepoDescription(std::string in) { this->repoDescription = in; }
  
  unsigned int getRepoId() { return this->id; }
  std::string getOwnerLogin() { return this->ownerLogin; }
  std::string getOwnerHtmlUrl() { return this->ownerHtmlUrl; }
  std::string getRepoName() { return this->repoName; }
  std::string getRepoFullName() { return this->repoFullName; }
  std::string getRepoHtmlUrl() { return this->repoHtmlUrl; }
  std::string getRepoDescription() { return this->repoDescription; }
  
private:
  unsigned int id;
  std::string ownerLogin;
  std::string ownerHtmlUrl;
  std::string repoName;
  std::string repoFullName;
  std::string repoHtmlUrl;
  std::string repoDescription;
};

#endif