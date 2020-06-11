#!/bin/bash
#
#(GWTriFold) buildTools/genDemoZip.sh
# create a copy of SampleApp, clear it of cached data, and zip it.
# Copyright 2013-2014 Nathan Ross (nrossit2@gmail.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cd `dirname ${BASH_SOURCE[0]}`
if [ -e GWTriFold_SampleApp.zip ]
then
rm GWTriFold_SampleApp.zip
fi
if [ -e GWTriFold_SampleApp ] 
then
rm -r GWTriFold_SampleApp 
fi
cp -r ../SampleApp GWTriFold_SampleApp 
rm -rf GWTriFold_SampleApp/gwt-unitCache GWTriFold_SampleApp/war/WEB-INF/classes/* GWTriFold_SampleApp/war/sample/*
zip -q -r /tmp/GWTriFold_SampleApp.zip GWTriFold_SampleApp
if [[ "$#" -gt 0 && "$1" = "b64" ]]
then
    echo -n "window.GWTriFold_Example=\"" > /tmp/GWTriFold_SampleApp_base64.js
    cat /tmp/GWTriFold_SampleApp.zip | base64 -w0 >> /tmp/GWTriFold_SampleApp_base64.js
    echo -n "\";" >> /tmp/GWTriFold_SampleApp_base64.js
fi
rm -r GWTriFold_SampleApp
