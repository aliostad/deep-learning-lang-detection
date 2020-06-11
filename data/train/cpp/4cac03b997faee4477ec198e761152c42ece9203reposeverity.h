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


#ifndef REPO_SEVERITY_H
#define REPO_SEVERITY_H

//------------------------------------------------------------------------------
#include "../repocoreglobal.h"

//------------------------------------------------------------------------------
#include <streambuf>
#include <string>
#include <iostream>
#include <ostream>
#include <sstream>

namespace repo {
namespace core {

/*!
 * Repo severity levels according to RFC 5424, the SysLog protocol.
 * See http://tools.ietf.org/html/rfc5424
 */
class REPO_CORE_EXPORT RepoSeverity
{


public :

typedef enum
{
    REPO_PANIC_NUM      = 7,
    REPO_ALERT_NUM      = 6,
    REPO_CRITICAL_NUM   = 5,
    REPO_ERROR_NUM      = 4,
    REPO_WARNING_NUM    = 3,
    REPO_NOTICE_NUM     = 2,
    REPO_INFO_NUM       = 1,
    REPO_DEBUG_NUM      = 0
} Level;

private:

    //! Private constructor.
    RepoSeverity(const std::string &color, const std::string &level, int);

public :

    //! Default constructor creates INFO-level severity.
    RepoSeverity();

    //! Equality comparison based on the underlying severity level strings.
    inline bool operator==(const RepoSeverity &s) const
    {   return
                this->color == s.color &&
                this->level == s.level &&
                this->value == s.value;  }

    //! Orders severity levels in descending order from PANIC to DEBUG
    inline bool operator<(const RepoSeverity &s) const
    {   return this->value < s.value; }

    //! Enable streaming of the severity level string representation.
    friend std::ostream& operator<<(std::ostream& os, const RepoSeverity &s)
    {   os << s.toString(); return os;  }

    //! Returns a string representation of the severity level.
    std::string toString() const { return level; }

    //! Returns the color associated with this severity level.
    std::string getColor() const { return color;}

    //! Returns numerical value of the severity.
    int getValue() const { return value; }

    /*!
     * Returns an integer representation of the severity level to use with
     * swtich statements. \sa Level
     */
    operator int() const { return value; }

    //! System is unusable.
    static const RepoSeverity REPO_PANIC;

    //! Action must be taken immediately.
    static const RepoSeverity REPO_ALERT;

    //! Critical conditions.
    static const RepoSeverity REPO_CRITICAL;

    //! Error conditions.
    static const RepoSeverity REPO_ERROR;

    //! Warning conditions.
    static const RepoSeverity REPO_WARNING;

    //! Normal but significant conditions.
    static const RepoSeverity REPO_NOTICE;

    //! Informational message.
    static const RepoSeverity REPO_INFO;

    //! Debug-level message.
    static const RepoSeverity REPO_DEBUG;

private:

    //! Color assigned to the severity level.
    std::string color;

    //! String representation of the severity level.
    std::string level;

    //! Integer representation of the severity level.
    int value;

}; // end class

} // end namespace core
} // end namespace repo

#endif // REPO_SEVERITY_H
