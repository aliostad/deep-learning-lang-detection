#include "stdlibrary.h"

#ifdef _WIN32
// DLL Entry Point ... nothing ...
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void *lpReserved) {
    return 1;
}
#endif
//-----------------------------------------------------------------------------------
float *GetFloatList(void *arr, INVOKE_CALL _Invoke) {
    INTEGER type      = 0;
    NUMBER  nr        = 0;
    void    *newpData = 0;
    float   *ret      = 0;

    int count = _Invoke(INVOKE_GET_ARRAY_COUNT, arr);

    ret        = new float[count + 1];
    ret[count] = 0;

    for (int i = 0; i < count; i++) {
        _Invoke(INVOKE_ARRAY_VARIABLE, arr, i, &newpData);
        if (newpData) {
            char    *szData;
            INTEGER type;
            NUMBER  nData;

            _Invoke(INVOKE_GET_VARIABLE, newpData, &type, &szData, &nData);
            if (type == VARIABLE_STRING) {
                ret[i] = 0;
            } else
                ret[i] = nData;
        }
    }
    return ret;
}

//-----------------------------------------------------//
char **GetCharList(void *arr, INVOKE_CALL _Invoke) {
    INTEGER type      = 0;
    NUMBER  nr        = 0;
    void    *newpData = 0;
    char    **ret     = 0;

    int count = _Invoke(INVOKE_GET_ARRAY_COUNT, arr);

    ret        = new char * [count + 1];
    ret[count] = 0;

    for (int i = 0; i < count; i++) {
        _Invoke(INVOKE_ARRAY_VARIABLE, arr, i, &newpData);
        if (newpData) {
            char    *szData;
            INTEGER type;
            NUMBER  nData;

            _Invoke(INVOKE_GET_VARIABLE, newpData, &type, &szData, &nData);
            if (type == VARIABLE_STRING) {
                ret[i] = szData;
            } else
                ret[i] = 0;
        }
    }
    return ret;
}

//-----------------------------------------------------//
int *GetIntList(void *arr, INVOKE_CALL _Invoke) {
    INTEGER type      = 0;
    NUMBER  nr        = 0;
    void    *newpData = 0;
    int     *ret      = 0;

    int count = _Invoke(INVOKE_GET_ARRAY_COUNT, arr);

    ret        = new int[count + 1];
    ret[count] = 0;

    for (int i = 0; i < count; i++) {
        _Invoke(INVOKE_ARRAY_VARIABLE, arr, i, &newpData);
        if (newpData) {
            char    *szData;
            INTEGER type;
            NUMBER  nData;

            _Invoke(INVOKE_GET_VARIABLE, newpData, &type, &szData, &nData);
            if (type == VARIABLE_STRING) {
                ret[i] = 0;
            } else
                ret[i] = (int)nData;
        }
    }
    return ret;
}

//-----------------------------------------------------//
double *GetDoubleList(void *arr, INVOKE_CALL _Invoke) {
    INTEGER type      = 0;
    NUMBER  nr        = 0;
    void    *newpData = 0;
    double  *ret      = 0;

    int count = _Invoke(INVOKE_GET_ARRAY_COUNT, arr);

    ret        = new double[count + 1];
    ret[count] = 0;

    for (int i = 0; i < count; i++) {
        _Invoke(INVOKE_ARRAY_VARIABLE, arr, i, &newpData);
        if (newpData) {
            char    *szData;
            INTEGER type;
            NUMBER  nData;

            _Invoke(INVOKE_GET_VARIABLE, newpData, &type, &szData, &nData);
            if (type == VARIABLE_STRING) {
                ret[i] = 0;
            } else
                ret[i] = nData;
        }
    }
    return ret;
}

//-----------------------------------------------------//
bool *GetBoolList(void *arr, INVOKE_CALL _Invoke) {
    INTEGER type      = 0;
    NUMBER  nr        = 0;
    void    *newpData = 0;
    bool    *ret      = 0;

    int count = _Invoke(INVOKE_GET_ARRAY_COUNT, arr);

    ret        = new bool[count + 1];
    ret[count] = 0;

    for (int i = 0; i < count; i++) {
        _Invoke(INVOKE_ARRAY_VARIABLE, arr, i, &newpData);
        if (newpData) {
            char    *szData;
            INTEGER type;
            NUMBER  nData;

            _Invoke(INVOKE_GET_VARIABLE, newpData, &type, &szData, &nData);
            if (type == VARIABLE_STRING) {
                ret[i] = 0;
            } else
                ret[i] = (bool)nData;
        }
    }
    return ret;
}

//-----------------------------------------------------//
