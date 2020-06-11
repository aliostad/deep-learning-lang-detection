var Utils = require('cloud/UtilitiesCC.js');
exports.seteDispatch = function (TheCall)
{    
    var eDispatch = new Object();
    pDispatch = TheCall.pDispatch;
    eDispatch.IsStandBy = false;
    var ErrorList = [];
    if (pDispatch.HasDataSet == false) 
    {
        var Error = new Object();
        Error.Level = "SECTION";
        Error.Type = "MAN";
        Error.Text = " eDispatch Null or Undefined"
        ErrorList.push(Error);
        eDispatch.Errors = ErrorList;
        return eDispatch;
    };
    
    if (typeof pDispatch.attributes.elements == 'undefined')
    {
        var Error = new Object();
        Error.Level = "SECTION";
        Error.Type = "MAN";
        Error.Text = " eDispatch Null or Undefined"
        ErrorList.push(Error);
        eDispatch.Errors = ErrorList;
        return eDispatch;
    };

    var _elementList = [];
    _elementList = pDispatch.attributes.elements;

    if (_elementList.length == 0)
    {
        var Error = new Object();
        Error.Level = "SECTION";
        Error.Type = "MAN";
        Error.Text = " eDispatch Missing Element List"
        ErrorList.push(Error);
        eDispatch.Errors = ErrorList;
        return eDispatch;
    };

    /////eDispatch.01////////////////////
        var _val = [];
        var _text = [];
        var _dispatch = [];
        var valObj = {};
        valObj.IsNull = true;
        _dispatch = Utils.getValue(_elementList, "eDispatch.01");

        if (_dispatch.IsNull == false) {
            _val.push(_dispatch.ValueArray[0].val);
            if (_val[0] == "2301065") //StandBy Call.  Special Call Type
            {
                eDispatch.IsStandBy = true;
            };
            valObj.IsNull = false;
            eDispatch["IsValid"] = true;
            _text.push(_dispatch.ValueArray[0].text);
            valObj.CodeText = _text.slice(0);
            valObj.vSet = _val.slice(0);
            eDispatch["eDispatch.01"] = valObj;
            delete valObj;
        }
        else {
            Error.Level = "ELEM";
            Error.Type = "MAN";
            Error.Att = "eDispatch.01"
            Error.Text = " Complaint Reported by Dispatch Undefined or Null"
            ErrorList.push(Error)
        };

        /////eDispatch.02////////////////////
        var _val = [];
        var _text = [];
        var _dispatch = [];
        var valObj = {};
        valObj.IsNull = true;
        _dispatch = Utils.getValue(_elementList, "eDispatch.02");
        if (_dispatch.IsNull == false)
        {
            _val.push(_dispatch.ValueArray[0].val);
            valObj.IsNull = false;
            _text.push(_dispatch.ValueArray[0].text);
        }
        else
        {
            if (eDispatch.IsStandBy == true)
            {
                _val.push(NOTAPPLICABLE);
                valObj.NV = true;
            }
            else
            {
                _val.push(NOTRECORDED);
                valObj.NV = true;
            }
        };
        valObj.CodeText = _text.slice(0);
        valObj.vSet = _val.slice(0);
        eDispatch["eDispatch.02"] = valObj;
        delete valObj;

        /////eDispatch.03////////////////////
        var _val = [];
        var _dispatch = [];
        var valObj = {};
        valObj.IsNull = true;
        _dispatch = Utils.getValue(_elementList, "eDispatch.03");

        if (_dispatch.IsNull == false)
        {
            _val.push(_dispatch.ValueArray[0].val);
            valObj.IsNull = false;
            valObj.vSet = _val.slice(0);
            eDispatch["eDispatch.03"] = valObj;
            delete valObj;
        };

        /////eDispatch.04////////////////////
        var _val = [];
        var _dispatch = [];
        var valObj = {};
        valObj.IsNull = true;
        _dispatch = Utils.getValue(_elementList, "eDispatch.04");
        if (_dispatch.IsNull == false)
        {
            _val.push(_dispatch.ValueArray[0].val);
            valObj.IsNull = false;
            valObj.vSet = _val.slice(0);
            eDispatch["eDispatch.04"] = valObj;
            delete valObj;
        };

        /////eDispatch.05////////////////////
        var _val = [];
        var _text = [];
        var _dispatch = [];
        var valObj = {};
        valObj.IsNull = true;
        _dispatch = Utils.getValue(_elementList, "eDispatch.05");
        if (_dispatch.IsNull == false)
        {
            valObj.IsNull = false;
            _val.push(_dispatch.ValueArray[0].val);
            _text.push(_dispatch.ValueArray[0].text);
            valObj.CodeText = _text.slice(0);
            valObj.vSet = _val.slice(0);
            eDispatch["eDispatch.05"] = valObj;
            delete valObj;
        }
  

    eDispatch.Errors = ErrorList;
    return eDispatch;
};
