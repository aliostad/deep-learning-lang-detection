/*
   Licensed to the Apache Software Foundation (ASF) under one or more
   contributor license agreements.  See the NOTICE file distributed with
   this work for additional information regarding copyright ownership.
   The ASF licenses this file to You under the Apache License, Version 2.0
   (the "License"); you may not use this file except in compliance with
   the License.  You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
 */
namespace stab.query {

	public interface FunctionT<TResult>           { TResult invoke(); }
	public interface FunctionBoolean              { bool invoke(); }
	public interface FunctionInt                  { int invoke(); }
	public interface FunctionLong                 { long invoke(); }
	public interface FunctionFloat                { float invoke(); }
	public interface FunctionDouble               { double invoke(); }

	public interface FunctionTBoolean<TArgument>  { bool invoke(TArgument argument); }
	public interface FunctionIntBoolean           { bool invoke(int argument); }
	public interface FunctionLongBoolean          { bool invoke(long argument); }
	public interface FunctionFloatBoolean         { bool invoke(float argument); }
	public interface FunctionDoubleBoolean        { bool invoke(double argument); }

	public interface FunctionTInt<TArgument>      { int invoke(TArgument argument); }
	public interface FunctionBooleanInt           { int invoke(bool argument); }
	public interface FunctionByteInt              { int invoke(byte argument); }
	public interface FunctionIntByte              { byte invoke(int argument); }
	public interface FunctionCharInt              { int invoke(char argument); }
	public interface FunctionIntChar              { char invoke(int argument); }
	public interface FunctionShortInt             { int invoke(short argument); }
	public interface FunctionIntShort             { short invoke(int argument); }
	public interface FunctionIntInt               { int invoke(int argument); }
	public interface FunctionIntT<TResult>        { TResult invoke(int argument); }
	
	public interface FunctionTLong<TArgument>     { long invoke(TArgument argument); }
	public interface FunctionIntLong              { long invoke(int argument); }
	public interface FunctionLongInt              { int invoke(long argument); }
	public interface FunctionLongLong             { long invoke(long argument); }
	public interface FunctionLongT<TResult>       { TResult invoke(long argument); }

	public interface FunctionTFloat<TArgument>    { float invoke(TArgument argument); }
	public interface FunctionIntFloat             { float invoke(int argument); }
	public interface FunctionLongFloat            { float invoke(long argument); }
	public interface FunctionFloatFloat           { float invoke(float argument); }
	public interface FunctionFloatT<TResult>      { TResult invoke(float argument); }

	public interface FunctionTDouble<TArgument>   { double invoke(TArgument argument); }
	public interface FunctionIntDouble            { double invoke(int argument); }
	public interface FunctionDoubleInt            { int invoke(double argument); }
	public interface FunctionLongDouble           { double invoke(long argument); }
	public interface FunctionFloatDouble          { double invoke(float argument); }
	public interface FunctionDoubleDouble         { double invoke(double argument); }
	public interface FunctionDoubleT<TResult>     { TResult invoke(double argument); }

	public interface FunctionTT<TArgument, TResult> { TResult invoke(TArgument argument); }

	public interface FunctionTIntBoolean<TArgument>  { bool invoke(TArgument argument1, int argument2); }
	public interface FunctionIntIntBoolean           { bool invoke(int argument1, int argument2); }
	public interface FunctionLongIntBoolean          { bool invoke(long argument1, int argument2); }
	public interface FunctionFloatIntBoolean         { bool invoke(float argument1, int argument2); }
	public interface FunctionDoubleIntBoolean        { bool invoke(double argument1, int argument2); }

	public interface FunctionTIntInt<TArgument>           { int invoke(TArgument argument1, int argument2); }
	public interface FunctionBooleanIntInt                { int invoke(bool argument1, int argument2); }
	public interface FunctionByteIntInt                   { int invoke(byte argument1, int argument2); }
	public interface FunctionShortIntInt                  { int invoke(short argument1, int argument2); }
	public interface FunctionCharIntInt                   { int invoke(char argument1, int argument2); }
	public interface FunctionIntIntInt                    { int invoke(int argument1, int argument2); }
	public interface FunctionLongIntInt                   { int invoke(long argument1, int argument2); }

	public interface FunctionIntIntT<TResult>             { TResult invoke(int argument1, int argument2); }
	public interface FunctionLongIntT<TResult>            { TResult invoke(long argument1, int argument2); }
	public interface FunctionFloatIntT<TResult>           { TResult invoke(float argument1, int argument2); }
	public interface FunctionDoubleIntT<TResult>          { TResult invoke(double argument1, int argument2); }

	public interface FunctionIntIntByte                   { byte invoke(int argument1, int argument2); }
	public interface FunctionIntIntChar                   { char invoke(int argument1, int argument2); }
	public interface FunctionIntIntDouble                 { double invoke(int argument1, int argument2); }
	public interface FunctionIntIntFloat                  { float invoke(int argument1, int argument2); }
	public interface FunctionIntIntLong                   { long invoke(int argument1, int argument2); }
	public interface FunctionIntIntShort                  { short invoke(int argument1, int argument2); }
	public interface FunctionLongIntDouble                { double invoke(long argument1, int argument2); }
	public interface FunctionLongIntFloat                 { float invoke(long argument1, int argument2); }
	public interface FunctionLongIntLong                  { long invoke(long argument1, int argument2); }
	public interface FunctionLongLongLong                 { long invoke(long argument1, long argument2); }
	public interface FunctionFloatFloatFloat              { float invoke(float argument1, float argument2); }
	public interface FunctionFloatIntDouble               { double invoke(float argument1, int argument2); }
	public interface FunctionFloatIntFloat                { float invoke(float argument1, int argument2); }
	public interface FunctionDoubleDoubleDouble           { double invoke(double argument1, double argument2); }

	public interface FunctionIntTInt<TArgument>           { int invoke(int argument1, TArgument argument2); }
	public interface FunctionTIntLong<TArgument>          { long invoke(TArgument argument1, int argument2); }
	public interface FunctionTIntFloat<TArgument>         { float invoke(TArgument argument1, int argument2); }
	public interface FunctionTIntDouble<TArgument>        { double invoke(TArgument argument1, int argument2); }
	public interface FunctionLongTLong<TArgument>         { long invoke(long argument1, TArgument argument2); }
	public interface FunctionFloatTFloat<TArgument>       { float invoke(float argument1, TArgument argument2); }
	public interface FunctionDoubleTDouble<TArgument>     { double invoke(double argument1, TArgument argument2); }
	
	public interface FunctionTIntT<TArgument, TResult>    { TResult invoke(TArgument argument1, int argument2); }
	public interface FunctionTLongT<TArgument, TResult>   { TResult invoke(TArgument argument1, long argument2); }
	public interface FunctionTFloatT<TArgument, TResult>  { TResult invoke(TArgument argument1, float argument2); }
	public interface FunctionTDoubleT<TArgument, TResult> { TResult invoke(TArgument argument1, double argument2); }

	public interface FunctionTTT<TArgument1, TArgument2, TResult> { TResult invoke(TArgument1 argument1, TArgument2 argument2); }

}
