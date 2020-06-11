function objSet(){
    // var k = $api.dom('.key').value;
    // var v = $api.dom('.value').value;
    var k = $api.dom('#key').value;
    var v = $api.dom('#value').value;
    api.setPrefs({
        key: k,
        value: v
    });
    api.alert({msg:'设置成功'},function(ret,err){});
};
function objGet(){
    // var k = $api.dom('.key1').value;
    var k = $api.dom('#key').value;
    api.getPrefs({
        key: k
    }, function(ret, err){
        var v = ret.value;
        // $api.dom('.value1').value = v;
        $api.dom('#value').value = v;
    });
};
function objDel(){
    // var k = $api.dom('.key2').value;
    var k = $api.dom('#key').value;
    api.removePrefs({
        key: k
    });
};