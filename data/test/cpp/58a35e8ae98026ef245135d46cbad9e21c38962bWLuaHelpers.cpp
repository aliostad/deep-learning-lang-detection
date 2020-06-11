#include "WLuaHelpers.h"
#include <QDebug>

namespace Wf {

// debug purpose only
void stackDump (lua_State* L)
{
	int i;
	int top = lua_gettop(L);
	const int BUFSIZE = 1024;
	char dump[BUFSIZE];

	qDebug() << "Stack Dump:  ";
	for (i = 1; i <= top; i++) {  /* repeat for each level */
		int t = lua_type(L, i);
		switch (t) {

		case LUA_TSTRING:  /* strings */
			sprintf_s(dump, BUFSIZE, "[%02d] `%s'", i, lua_tostring(L, i));
			qDebug() << dump;
			break;

		case LUA_TBOOLEAN:  /* booleans */
			sprintf_s(dump, BUFSIZE, "[%02d] %s", i, (lua_toboolean(L, i) ? "true" : "false"));
			qDebug() << dump;
			break;

		case LUA_TNUMBER:  /* numbers */
			sprintf_s(dump, BUFSIZE, "[%02d] %g", i, lua_tonumber(L, i));
			qDebug() << dump;
			break;

		default:  /* other values */
			sprintf_s(dump, BUFSIZE, "[%02d] %s", i, lua_typename(L, t));
			qDebug() << dump;
			break;

		}
	}
	qDebug() << "\n";  /* end the listing */
}

} // namespace Wf
