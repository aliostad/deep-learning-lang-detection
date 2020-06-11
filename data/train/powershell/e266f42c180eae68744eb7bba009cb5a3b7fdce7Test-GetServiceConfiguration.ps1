# Copyright 2012 Aaron Jensen
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

function Start-TestFixture
{
    & (Join-Path -Path $PSScriptRoot -ChildPath '..\Import-CarbonForTest.ps1' -Resolve)
}

function Test-ShouldLoadAllServiceConfiguration
{
    Get-Service | Get-ServiceConfiguration | Format-List -Property *
    Assert-NoError
}

function Test-ShouldLoadExtendedTypeData
{
    Get-Service | ForEach-Object {
        $service = $_
        $info = Get-ServiceConfiguration -Name $service.Name
        $info | Get-Member -MemberType Property | ForEach-Object { Assert-Equal $info.($_.Name) $service.($_.Name) $_.Name }
    }
    Assert-NoError

}

