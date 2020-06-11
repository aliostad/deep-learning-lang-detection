/**
 *  Copyright (C) 2014 3D Repo Ltd
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "repologger.h"
//------------------------------------------------------------------------------
#include <ctime>
#include <stdio.h>
//------------------------------------------------------------------------------
#if defined(_WIN32) || defined(_WIN64)
#   include <direct.h>
#   define getcwd _getcwd
#   define PATH_SEPARATOR "\\"
#else
#   include <unistd.h>
#   define PATH_SEPARATOR "/"
#endif

//------------------------------------------------------------------------------

const std::string repo::core::RepoLogger::DEFAULT_LOG_EXTENSION = ".log";

//------------------------------------------------------------------------------
//
// Private
//
//------------------------------------------------------------------------------

repo::core::RepoLogger::RepoLogger()
    : coutStreamBuffer(0)
    , cerrStreamBuffer(0)
{
   // coutStreamBuffer = new RepoStreamBuffer(this, std::cout);
    //freopen(getFilename().c_str(), "a", stdout);

  //  cerrStreamBuffer = new RepoStreamBuffer(this, std::cerr);
    //freopen(getFilename().c_str(), "a", stderr);
}

repo::core::RepoLogger::~RepoLogger()
{    
    // Clean up allocated memory
    if (coutStreamBuffer)
        delete coutStreamBuffer;
    //fclose(stdout);

    if (cerrStreamBuffer)
        delete cerrStreamBuffer;
    //fclose(stderr);
}

//------------------------------------------------------------------------------
//
// Public
//
//------------------------------------------------------------------------------

repo::core::RepoLogger &repo::core::RepoLogger::instance()
{
    // Static variable is created and destroyed only once.
    static RepoLogger instance;
    return instance;
}

std::string repo::core::RepoLogger::getHtmlFormattedMessage(
        const std::string &message,
        const RepoSeverity &severity) const
{
    std::stringstream formatted;

    //--------------------------------------------------------------------------
    // Retrieve current time
    time_t t = time(0);   // get time now
    const struct tm *now = localtime(&t);
    formatted << normalize(now->tm_hour);
    formatted << ":";
    formatted << normalize(now->tm_min);
    formatted << ":";
    formatted << normalize(now->tm_sec);
    formatted << " - ";

    //-------------------------------------------------------------------------
    // HTML formatting
    formatted << "<span style='color:";
    formatted << severity.getColor();
    formatted << "'>";
    formatted << severity;
    formatted << "</span> - ";

    //--------------------------------------------------------------------------
    // Code formatting for debug severity level only
    if (severity.getValue() == RepoSeverity::REPO_DEBUG_NUM)
        formatted << "<code>" << message << "</code>";
    else
        formatted << message;

    formatted << "<br/>";
    return formatted.str();
}

std::string repo::core::RepoLogger::getFilename(
        const std::string &extension)
{
    std::stringstream fileNameStream;
    time_t t = time(0);
    const struct tm *now = localtime(&t);
    fileNameStream << (now->tm_year + 1900);
    fileNameStream << "-";
    fileNameStream << normalize(now->tm_mon + 1);
    fileNameStream << "-";
    fileNameStream << normalize(now->tm_mday);
    fileNameStream << extension;

    std::string generated = fileNameStream.str();
    if (generated != filename)
    {
        filename = generated;
        log("Log: " + getFullFilePath(),
            RepoSeverity::REPO_NOTICE);
    }
    return filename;
}

std::string repo::core::RepoLogger::getFullFilePath()
{
    return getWorkingDirectory() + PATH_SEPARATOR + getFilename();
}

std::string repo::core::RepoLogger::getWorkingDirectory()
{
    char temp[FILENAME_MAX];
    return (getcwd(temp, FILENAME_MAX) ? std::string(temp) : std::string());
}

void repo::core::RepoLogger::log(
        const std::string &msg,
        const RepoSeverity &severity)
{
    std::string filename = getFilename();
    std::string formattedMessage = getHtmlFormattedMessage(msg, severity);

    notifyListeners(formattedMessage);

    std::ofstream file(filename, std::ios::app);
    if (!file.is_open())
    {
        notifyListeners(
                    getHtmlFormattedMessage(
                        "Cannot write to log file: " + getFullFilePath(),
                        RepoSeverity::REPO_CRITICAL));
    }
    else
    {
        file << formattedMessage << std::endl;
        file.close();
    }
}

void repo::core::RepoLogger::messageGenerated(
        const std::ostream *sender,
        const std::string &message)
{
    log(message, sender == &(std::cerr)
        ? RepoSeverity::REPO_ERROR
        : RepoSeverity::REPO_INFO);
}

std::string repo::core::RepoLogger::normalize(int n)
{
    std::stringstream str;
    if (n < 10)
        str << "0";
    str << n;
    return str.str();
}
