# Copyright 2014 FreemanSoft Inc
# Licensed under the Apache License, Version 2.0 (the "License");
#
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
#
# The code generator adds javadoc to generated java files

echo "Hacking generated Java files to add javadoc"
$pathtofiles = "generated\jvm\freemansoft\performancecounters"
$sourceForFacade = "WindowsPerformanceFacade.java"

###############################################
# class level
###############################################

$newFacadeClassDoc ='/**
 * Java proxy for the C# WindowsPerformanceFacade class.
 * This is a static wrapper for the Windows Performance Counters 
 * that uses an integer key for the category/counter names to speed up performance
 * First get a key for a category/instance/counter combination.
 * Then use that integer key to manipulate the counters with the rest of the API
 */
@net.sf.jni4net.attributes.ClrType'

$newFacadeClassDocPattern = "@net.sf.jni4net.attributes.ClrType"
(Get-Content $pathtofiles\$sourceForFacade -Raw ).Replace("$newFacadeClassDocPattern"
    ,"$newFacadeClassDoc") | Set-Content $pathtofiles\$sourceForFacade
    
###############################################
# counter manipulation
###############################################

$newFacadeIncrement ='/**
     * Increment the specified counter by the specified amount.
     * Increment any paired base counter by 1
     * @param counterKey a counter identifier retrieved from GetPerformanceCounterId
     * @param incrementAmount the amount to increment a counter
     */
    @net.sf.jni4net.attributes.ClrMethod("(IJ)V")
    public native static void Increment(int counterKey);'
$newFacadeIncrementBy='/**
     * Increment the specified counter by the specified amount.
     * Increment any paired base counter by 1
     * @param counterKey a counter identifier retrieved from GetPerformanceCounterId
     * @param incrementAmount the amount to increment a counter
     */
    @net.sf.jni4net.attributes.ClrMethod("(IJ)V")
    public native static void IncrementBy(int counterKey, long incrementAmount);'
$newFacadeIncrementByWithBase='/**
     * Increment the specified counter by the specified amount.
     * Increment any paired base counter by the specified amount
     * @param counterKey a counter identifier retrieved from GetPerformanceCounterId
     * @param incrementAmount the amount to increment a counter
     * @param incrementBaseAmount the amount to increment the base counter
     */
    @net.sf.jni4net.attributes.ClrMethod("(IJJ)V")
    public native static void IncrementBy(int counterKey, long incrementAmount, long incrementBaseAmount);'
$newFacadeDecrement='/**
     * Decrement the specified counter by 1
     * Increment any paired base counter by 1
     * @param counterKey a counter identifier retrieved from GetPerformanceCounterId
     */
    @net.sf.jni4net.attributes.ClrMethod("(I)V")
    public native static void Decrement(int counterKey);'
$newFacadeNextValue='/**
     * Retrieve the calculated value of this counter
     * @param counterKey a counter identifier retrieved from GetPerformanceCounterId
     */
    @net.sf.jni4net.attributes.ClrMethod("(I)F")
    public native static float NextValue(int counterKey);'

$newFacadeIncrementPattern = "@net.sf.jni4net.attributes.ClrMethod(`"(I)V`")`r`n    public native static void Increment(int counterKey);"
$newFacadeIncrementByPattern = "@net.sf.jni4net.attributes.ClrMethod(`"(IJ)V`")`r`n    public native static void IncrementBy(int counterKey, long incrementAmount);"
$newFacadeIncrementByWithBasePattern = "@net.sf.jni4net.attributes.ClrMethod(`"(IJJ)V`")`r`n    public native static void IncrementBy(int counterKey, long incrementAmount, long incrementBaseAmount);"
$newFacadeDecrementPattern = "@net.sf.jni4net.attributes.ClrMethod(`"(I)V`")`r`n    public native static void Decrement(int counterKey);"
$newFacadeNextValuePattern = "@net.sf.jni4net.attributes.ClrMethod(`"(I)F`")`r`n    public native static float NextValue(int counterKey);"
(Get-Content $pathtofiles\$sourceForFacade -Raw ).Replace("$newFacadeIncrementPattern"
    ,"$newFacadeIncrement") | Set-Content $pathtofiles\$sourceForFacade
(Get-Content $pathtofiles\$sourceForFacade -Raw ).Replace("$newFacadeIncrementByPattern"
    ,"$newFacadeIncrementBy") | Set-Content $pathtofiles\$sourceForFacade
(Get-Content $pathtofiles\$sourceForFacade -Raw ).Replace("$newFacadeIncrementByWithBasePattern"
    ,"$newFacadeIncrementByWithBase") | Set-Content $pathtofiles\$sourceForFacade
(Get-Content $pathtofiles\$sourceForFacade -Raw ).Replace("$newFacadeDecrementPattern"
    ,"$newFacadeDecrement") | Set-Content $pathtofiles\$sourceForFacade
(Get-Content $pathtofiles\$sourceForFacade -Raw ).Replace("$newFacadeNextValuePattern"
    ,"$newFacadeNextValue") | Set-Content $pathtofiles\$sourceForFacade
    
###############################################
# counter management
###############################################
$newFacadeCacheCounters='/**
     * Creates proxies for the requested counter. This only needs to be done once per counter.
     * This is a very slow, almost 400ms, operation.  Do it in setup if you do not want a first time hit.
     * @param categoryName the name of the category
     * @param instanceName the optional name of the instance. You can pass null or empty string for default instance
     * @param counterName the name of the counter
     */
    @net.sf.jni4net.attributes.ClrMethod("(LSystem/String;LSystem/String;)V")
    public native static void CacheCounters('
$newFacadeGetPerformanceCounterId='/**
     * Create a unique integer key to represent the category, instance and counter name combination.
     * @param categoryName the name of the category
     * @param instanceName the optional name of the instance. You can pass null or empty string for default instance
     * @param counterName the name of the counter
     * @return the unique id for this counter
     */
    @net.sf.jni4net.attributes.ClrMethod("(LSystem/String;LSystem/String;LSystem/String;)I")
    public native static int GetPerformanceCounterId('    
$newFacadeCacheCountersPattern = "@net.sf.jni4net.attributes.ClrMethod(`"(LSystem/String;LSystem/String;)V`")`r`n    public native static void CacheCounters("
$newFacadeGetPerformanceCounterIdPattern = "@net.sf.jni4net.attributes.ClrMethod(`"(LSystem/String;LSystem/String;LSystem/String;)I`")`r`n    public native static int GetPerformanceCounterId("
(Get-Content $pathtofiles\$sourceForFacade -Raw ).Replace("$newFacadeCacheCountersPattern"
    ,"$newFacadeCacheCounters") | Set-Content $pathtofiles\$sourceForFacade
(Get-Content $pathtofiles\$sourceForFacade -Raw ).Replace("$newFacadeGetPerformanceCounterIdPattern"
    ,"$newFacadeGetPerformanceCounterId") | Set-Content $pathtofiles\$sourceForFacade
    
###############################################
# Raw value
###############################################
$newFacadeSetRawValue='/**
     * Sets the raw value on a counter.
     * Does not effect any associated base counter
     * @param counterKey a counter identifier retrieved from GetPerformanceCounterId
     * @param value new raw value amount
     */
    @net.sf.jni4net.attributes.ClrMethod("(IJ)V")
    public native static void SetRawValue(int counterKey, long value);'
$newFacadeGetRawValue='/**
     * Gets the current raw value for the counter.  This can be a different value than the NextValue
     * @param counterKey a counter identifier retrieved from GetPerformanceCounterId
     * @return the current raw value for this counter
     */
    @net.sf.jni4net.attributes.ClrMethod("(I)J")
    public native static long GetRawValue(int counterKey);'
$newFacadeSetRawValuePattern = "@net.sf.jni4net.attributes.ClrMethod(`"(IJ)V`")`r`n    public native static void SetRawValue(int counterKey, long value);"
$newFacadeGetRawValuePattern = "@net.sf.jni4net.attributes.ClrMethod(`"(I)J`")`r`n    public native static long GetRawValue(int counterKey);"
(Get-Content $pathtofiles\$sourceForFacade -Raw ).Replace("$newFacadeSetRawValuePattern"
    ,"$newFacadeSetRawValue") | Set-Content $pathtofiles\$sourceForFacade
(Get-Content $pathtofiles\$sourceForFacade -Raw ).Replace("$newFacadeGetRawValuePattern"
    ,"$newFacadeGetRawValue") | Set-Content $pathtofiles\$sourceForFacade

    
###############################################
# Stopwatch
###############################################
$newFacadeStopwatchTimestamp='/**
     * Returns the raw value of the system timer, a high speed timer used by windows performance counters.
     * Use this value or a difference of two calls of this when doing time based counter updates.
     * This is not the current time in milliseconds.
     * @return the current raw value for this counter
     */
    @net.sf.jni4net.attributes.ClrMethod("()J")
    public native static long StopwatchTimestamp();'
$newFacadeStopwatchTimestampPattern = "@net.sf.jni4net.attributes.ClrMethod(`"()J`")`r`n    public native static long StopwatchTimestamp();"
(Get-Content $pathtofiles\$sourceForFacade -Raw ).Replace("$newFacadeStopwatchTimestampPattern"
    ,"$newFacadeStopwatchTimestamp") | Set-Content $pathtofiles\$sourceForFacade
        