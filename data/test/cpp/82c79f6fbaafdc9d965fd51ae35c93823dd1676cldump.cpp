/*
** $Id: ldump.c,v 1.19 2011/11/23 17:48:18 lhf Exp $
** save precompiled Lua chunks
** See Copyright Notice in lua.h
*/

#include "LuaProto.h"
#include "LuaState.h"

#include <stddef.h>

#define ldump_c

#include "lua.h"

#include "lobject.h"
#include "lstate.h"
#include "lundump.h"

typedef struct {
 LuaThread* L;
 lua_Writer writer;
 void* data;
 int strip;
 int status;
} DumpState;

#define DumpMem(b,n,size,D)	DumpBlock(b,(n)*(size),D)
#define DumpVar(x,D)		DumpMem(&x,1,sizeof(x),D)

static void DumpBlock(const void* b, size_t size, DumpState* D)
{
 if (D->status==0)
 {
  D->status=(*D->writer)(D->L,b,size,D->data);
 }
}

static void DumpChar(int y, DumpState* D)
{
 char x=(char)y;
 DumpVar(x,D);
}

static void DumpInt(int x, DumpState* D)
{
 DumpVar(x,D);
}

static void DumpNumber(double x, DumpState* D)
{
 DumpVar(x,D);
}

static void DumpVector(const void* b, int n, size_t size, DumpState* D)
{
 DumpInt(n,D);
 DumpMem(b,n,size,D);
}

static void DumpString(const LuaString* s, DumpState* D)
{
 if (s==NULL)
 {
  size_t size=0;
  DumpVar(size,D);
 }
 else
 {
  size_t size=s->getLen()+1;		/* include trailing '\0' */
  DumpVar(size,D);
  DumpBlock(s->c_str(),size*sizeof(char),D);
 }
}

#define DumpCode(f,D)	 DumpVector(&f->instructions_[0],(int)f->instructions_.size(),sizeof(Instruction),D)

static void DumpFunction(const LuaProto* f, DumpState* D);

static void DumpConstants(const LuaProto* f, DumpState* D)
{
  int n = (int)f->constants.size();
  DumpInt(n,D);
  for(int i=0; i < n; i++)
  {
    LuaValue v = f->constants[i];
    DumpChar(v.type(),D);

    if(v.isBool()) {
      DumpChar(v.getBool() ? 1 : 0,D);
    } else if(v.isNumber()) {
      DumpNumber(v.getNumber(),D);
    } else if(v.isString()) {
      DumpString(v.getString(),D);
    }
  }
  n = (int)f->subprotos_.size();
  DumpInt(n,D);
  for (int i=0; i < n; i++) {
    DumpFunction(f->subprotos_[i],D);
  }
}

static void DumpUpvalues(const LuaProto* f, DumpState* D)
{
 int i,n=(int)f->upvalues.size();
 DumpInt(n,D);
 for (i=0; i<n; i++)
 {
  DumpChar(f->upvalues[i].instack,D);
  DumpChar(f->upvalues[i].idx,D);
 }
}

static void DumpDebug(const LuaProto* f, DumpState* D)
{
 int i,n;
 DumpString((D->strip) ? NULL : f->source,D);
 n= (D->strip) ? 0 : (int)f->lineinfo.size();
 DumpVector(f->lineinfo.begin(),n,sizeof(int),D);
 n= (D->strip) ? 0 : (int)f->locvars.size();
 DumpInt(n,D);
 for (i=0; i<n; i++)
 {
  DumpString(f->locvars[i].varname,D);
  DumpInt(f->locvars[i].startpc,D);
  DumpInt(f->locvars[i].endpc,D);
 }
 n= (D->strip) ? 0 : (int)f->upvalues.size();
 DumpInt(n,D);
 for (i=0; i<n; i++) DumpString(f->upvalues[i].name,D);
}

static void DumpFunction(const LuaProto* f, DumpState* D)
{
 DumpInt(f->linedefined,D);
 DumpInt(f->lastlinedefined,D);
 DumpChar(f->numparams,D);
 DumpChar(f->is_vararg ? 1 : 0,D);
 DumpChar(f->maxstacksize,D);
 DumpCode(f,D);
 DumpConstants(f,D);
 DumpUpvalues(f,D);
 DumpDebug(f,D);
}

static void DumpHeader(DumpState* D)
{
 uint8_t h[LUAC_HEADERSIZE];
 luaU_header(h);
 DumpBlock(h,LUAC_HEADERSIZE,D);
}

/*
** dump Lua function as precompiled chunk
*/
int luaU_dump (LuaThread* L, const LuaProto* f, lua_Writer w, void* data, int strip)
{
 THREAD_CHECK(L);
 DumpState D;
 D.L=L;
 D.writer=w;
 D.data=data;
 D.strip=strip;
 D.status=0;
 DumpHeader(&D);
 DumpFunction(f,&D);
 return D.status;
}
