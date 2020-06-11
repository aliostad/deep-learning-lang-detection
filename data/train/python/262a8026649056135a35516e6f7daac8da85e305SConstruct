#            tastes like -*- python -*-

# Copyright 2007 Hewlett-Packard Development Company, L.P.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; version 2 of the License.
#   
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#   
# You should have received a copy of the GNU Lesser General Public
# License along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#

# Author: Tim Potter <tpot@hp.com>

import os

# CmpiCpp library

my_env = Environment()

prefix = ARGUMENTS.get('PREFIX', '/usr/local')

my_env.Append(CCFLAGS = ['-g', '-W', '-Wall', '-Wno-multichar', '-Werror'],
              CPPPATH = ['/usr/include/cmpi'],
              ENV = {'HOME': os.environ['HOME']},
              PREFIX = prefix)

libCmpiCpp_source = [
    'CmpiName.cpp',
    'CmpiStatus.cpp',
    'CmpiData.cpp',
    'CmpiObjectPath.cpp',
    'CmpiInstance.cpp',
    'CmpiResult.cpp',
    'CmpiContext.cpp',
    'CmpiArray.cpp',
    'CmpiArgs.cpp',
    'CmpiEnumeration.cpp',
    'CmpiDateTime.cpp',
    'CmpiProvider.cpp',
    'CmpiInstanceProvider.cpp',
    'CmpiAssociationProvider.cpp',
    'CmpiMethodProvider.cpp',
    'CmpiIndicationProvider.cpp',
    'CmpiBroker.cpp',
]

libCmpiCpp = my_env.SharedLibrary(
    'libCmpiCpp',
    source = libCmpiCpp_source)

my_env.Alias('install',
             my_env.Install('$PREFIX/lib', libCmpiCpp))

libCmpiCpp_headers = [
    'CmpiCpp.h',
    'CmpiStatus.h',
    'CmpiName.h',
    'CmpiArray.h',
    'CmpiData.h',
    'CmpiObjectPath.h',
    'CmpiInstance.h',
    'CmpiResult.h',
    'CmpiContext.h',
    'CmpiArgs.h',
    'CmpiEnumeration.h',
    'CmpiDateTime.h',
    'CmpiProvider.h',
    'CmpiInstanceProvider.h',
    'CmpiAssociationProvider.h',
    'CmpiMethodProvider.h',
    'CmpiIndicationProvider.h',
    'CmpiBroker.h',
]

my_env.Alias('install',
             my_env.Install('$PREFIX/include/cmpicpp', 
                            libCmpiCpp_headers))

# CmpiCppBroker library

libCmpiCppBroker_source = [
    'CmpiBrokerBroker.cpp',
    'CmpiBrokerArray.cpp',
    'CmpiBrokerInstance.cpp',
    'CmpiBrokerObjectPath.cpp',
    'CmpiBrokerResult.cpp',
    'CmpiBrokerString.cpp',
    'CmpiBrokerEnumeration.cpp',
    'CmpiBrokerContext.cpp',
    'CmpiBrokerDateTime.cpp',
    'UnimplementedFT.cpp',
]

libCmpiCppBroker = my_env.SharedLibrary(
    'libCmpiCppBroker',
    source = libCmpiCppBroker_source)

my_env.Alias('install',
             my_env.Install('$PREFIX/lib', libCmpiCppBroker))

libCmpiCppBroker_headers = [
    'CmpiCppBroker.h',
    'CmpiBrokerBroker.h',
    'CmpiBrokerArray.h',
    'CmpiBrokerInstance.h',
    'CmpiBrokerObjectPath.h',
    'CmpiBrokerResult.h',
    'CmpiBrokerString.h',
    'CmpiBrokerEnumeration.h',
    'CmpiBrokerContext.h',
    'CmpiBrokerDateTime.h',
    'UnimplementedFT.h',
]

my_env.Alias('install',
             my_env.Install('$PREFIX/include/cmpicpp', 
                            libCmpiCppBroker_headers))
