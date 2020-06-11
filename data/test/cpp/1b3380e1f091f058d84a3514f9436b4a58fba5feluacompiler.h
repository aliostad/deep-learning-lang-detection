#ifndef LUACOMPILER_H
#define LUACOMPILER_H

/*
* class LuaCompiler
* author  Rodrigo Monteiro 1313493
* brief Módulo responsável pela compilação de scripts Lua
* version
*   10/2014 1.0 Módulo inicial
*   11/2014 1.1 Módulo finalizado
*/

#include "lua.hpp"
#include "lauxlib.h"
#include "lobject.h"
#include "lstate.h"
#include "lundump.h"

/**
 * @brief Classe LuaCompiler
 */
class LuaCompiler
{
public:
    /**
     * @brief ctor
     */
    LuaCompiler();

    /**
     * @brief compile method for compile a Lua script
     * @param L Lua machine
     * @param f Lua prototype
     * @param w callback to function that write the current processed chunk
     * @param data the script Lua
     * @param strip to strip the chunks
     * @return status of compilation
     */
    int compile(lua_State* L, const Proto* f, lua_Writer w, void* data, bool strip);

private:

    /**
     * @brief header write the header of file
     * @param h pointer to header data
     */
    void header(lu_byte* h);
    /**
     * @brief dumpBlock callback to write the compiled chunk
     * @param b chunk compiled
     * @param size size of chunk
     */
    void dumpBlock(const void* b, size_t size);
    /**
     * @brief dumpChar Dump one char
     * @param y the char represented as int number
     */
    void dumpChar(int y);
    /**
     * @brief dumpInt Dump one integer
     * @param x the integer
     */
    void dumpInt(int x);
    /**
     * @brief dumpNumber Dump a double number
     * @param x the number
     */
    void dumpNumber(lua_Number x);
    /**
     * @brief dumpVector Dump a vector of bytes
     * @param b the data to be dumped
     * @param n count of data
     * @param size the size of data in bytes
     */
    void dumpVector(const void* b, int n, size_t size);
    /**
     * @brief dumpString Dump a string
     * @param s the string
     */
    void dumpString(const TString* s);
    /**
     * @brief dumpFunction Dump a Lua Function
     * @param f the prototype with the function
     */
    void dumpFunction(const Proto* f);
    /**
     * @brief dumpConstants Dump constants
     * @param f the prototype with the constant
     */
    void dumpConstants(const Proto* f);
    /**
     * @brief dumpUpvalues Dump upvalues
     * @param f the prototype with the upvalues
     */
    void dumpUpvalues(const Proto* f);
    /**
     * @brief dumpDebug Dump a Lua debug
     * @param f the prototype with the debug
     */
    void dumpDebug(const Proto* f);
    /**
     * @brief dumpHeader @see{LuaCompiler::header}
     */
    void dumpHeader();
    //macros
    /**
     * @brief dumpCode Dump a Lua code
     * @param f the prototype with the Lua code
     */
    void dumpCode(const Proto* f);
    /**
     * @brief dumpMem dump memory
     * @param b the data to be dumped
     * @param count count of data
     * @param size size of data in bytes
     */
    void dumpMem(const void* b, int count, size_t size);
    /**
     * @brief dumpVar Dump a variable
     * @param x the variable
     * @param size the size of variable
     */
    void dumpVar(const void* x, size_t size);

private:

    /**
     * @brief m_state pointer to Lua machine
     */
    lua_State* m_state;
    /**
     * @brief m_writer callback used to dump chunks
     */
    lua_Writer m_writer;
    /**
     * @brief m_data pointer to compiled script
     */
    void*      m_data;
    /**
     * @brief m_strip strip or not strip
     */
    bool       m_strip;
    /**
     * @brief m_status status of compilation
     */
    int        m_status;
};

#endif // LUACOMPILER_H
