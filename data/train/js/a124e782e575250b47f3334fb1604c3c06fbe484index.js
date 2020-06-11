/**
 * Created by chen on 2015/2/18.
 */
$(function () {


//        $.extend('test', function () {
//            alert('haha');
//        });
    var obj = {};
//        $.extend(obj, {
//            test: function () {
//                alert('haha');
//            }
//        });
    var test = -Infinity;
    console.log(test);
    var n = 13578578.54878978;
    console.log('n: ' + n);
    $.fn.extend({
        test: function () {
            console.log(this);
            console.log('haha');
        }
    });
    $.fn.extend({
        header: function (header) {
            this.append('<p class="header h '+ header.replace(/ /,'Spac').toLowerCase()+'">' + header+ '</p>');
            $('.head').append('<div class="h-'+ header.replace(/ /,'Spac').toLowerCase() +'">'+ header +'</div>');
            return this
        },
        show: function (com,type) {
//            console.log(com);
//                var result = eval(com) ? eval(com) : 'Wrong';
            result = eval(com);
            var model = $('<span class="commander">' +
                com +'&nbsp;--&gt; '+
                '</span><span class="result">' +
                result +
                '</span><br>');
            if (type) {model.addClass(type)}
            this.append(model);
            return this;
        },
        log: function (message) {
            this.append('<p class="log">'+ message.replace(/\n/g,'<br>') +'</p>');
            return this;
        },
        row: function () {
            this.append('<div class="row" style="display: block;">&nbsp;</div>');
            return this;
        }
    });
    var object = new Object(Number);
    var testA ={a:1};
    var valueOf  = {valueOf: function () {
        return 1;
    }};
    var toString = {toString: function () {
        return 2;
    }};
    var testConvert = {} +{};
    var testSequence = {
        valueOf: function () {
            return 1;
        },
        toString: function () {
            return 2;
        }
    }
    $('.javascript-exercise')
        .header('Number')
        .show('Number.MAX_VALUE')
        .show('Number.MIN_VALUE')
        .show('Number.NaN')
        .show('Number.NEGATIVE_INFINITY')
        .show('Number.POSITIVE_INFINITY')
        .row()
        .show('n')
        .show('n.toExponential()')
        .show('n.toExponential(5)')
        .show('n.toFixed()')
        .show('n.toFixed(2)')
        .show('n.toString()')
        .show('n.toLocaleString()')
        .show('n.toPrecision()')
        .show('n.toPrecision(1)')
        .show('n.valueOf(n.toPrecision())')
        .log('整数以浮点数形式存储')
        .show('1 === 1.0')
        .show('1 + 1.0')
        .log('浮点数不是精确的值')
        .show('0.1 + 0.2 === 0.3')
        .show('0.3 / 0.1')
        .show('(0.3 - 0.2) === (0.2- 0.1)')
        .log('大于2的53次方后，整数运算结果出错')
        .show('Math.pow(2,53)')
        .show('Math.pow(2,53) + 1')
        .show('Math.pow(2,53) + 2')
        .show('Math.pow(2,53) + 3')
        .show('Math.pow(2,53) + 4')
        .log('大于2的53次方后，多出来的有效数字无法保存')
        .show('9007199254740992111')
        .row()
        .show('588e+6')
        .show('126e-3')
        .show('1234567890123456789012')
        .show('123456789012345678901')
        .show('0.0000003 ')
        .show('0.000003 ')
        .show('0xff')
        .show('0377')
        .row()
        .show('typeof NaN')
        .show('NaN == NaN')
        .show('NaN === NaN')
        .show('isNaN(NaN)')
        .log('isNaN(\'Hello\') Same To isNaN(Number(\'Hello\'))')
        .show('isNaN(\'Hello\')')
        .show('isNaN({})')
        .show('isNaN(["array"])')
        .log('数组内部indexOf 使用严格相等运算符')
        .show('[NaN].indexOf(NaN)')
        .row()
        .show('6.5 % 2.1')
        .row()
        .log('原始数据类型转换成数值类型再进行比较')
        .show('"true" == true')
        .show('"" == false')
        .show('1 == true')
        .show('2 == true')
        .show('2 == false')
        .show('"\\n   123  \\t" == 123')
        .log('对象转换为基本类型的值再比较')
        .show('[1] == 1')
        .show('[1] == true')
        .show('[1] == "true"')
        .show('[1] == "1"')
        .show('undefined == null')
        .row()
        .show('"" == "0"')
        .show('0 == ""')
        .show('0 == "0"')
        .row()
        .show('false == "false"')
        .show('false == "0"')
        .show('false == undefined')
        .show('false == null')
        .show('null == undefined')
        .show('"\\t\\r\\n" == 0')
        .log('~ 等于 取反-1')
        .show('~ -1')
        .show('~ -2')
        .show('~ -848')
        .show('~ 1')
        .show('~ 2')
        .show('~ 848')
        .log('~~ 最快取整')
        .show('~~ 2.9')
        .log('Same To-->~Number(\'011\')')
        .show('~ "011"')
        .show('~ "42 cats"')
        .show('~ "0xcafebabe"')
        .show('~ "deadbeef"')
        .log('Same To-->~~Number("011")')
        .show('~~ "011"')
        .show('~~ "42 cats"')
        .show('~~ "0xcafebabe"')
        .show('~~ "deadbeef"')
        .log('^ 结果不同为1，结果相同为0')
        .show('0 ^ 3')
        .log('连续对a, b进行3次异或可交换两个数的值')
        .log('a^=b b^=a a^=b //--> a<->b')
        .header('String')
        .log('\\251  \\xA9 \\u00A9')
        .show('"\251"')
        .show('"\xA9"')
        .show('"\u00A9"')
        .log('base 64 不适用于非ASCII码的字符')
        .show('window.btoa("Hello World")')
        .show('window.atob("SGVsbG8gV29ybGQ=")')
        .header('Object')
        .log('var object = new Object(Number)')
        .show('object')
        .show('object.prototype')
        .show('object.constructor()')
        .show('object.toLocalString')
        .show('object.toString()')
        .header('data type')
//        .show('testA')
        .log('var testA = {a:1}')
        .show('Number(testA)')
        .log('var valueOf = {valueOf: function(){return 1;}}')
        .show('Number(valueOf)')
        .log('var toString = {toString: function(){return 2;}}')
        .show('Number(toString)')
        .log('var testSequence = {\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;valueOf: function(){return 1;},\n' +
            '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;toString: function(){return: 2;}}')
        .show('Number(testSequence)')
        .row()
        .show('parseInt(testA)')
        .show('parseInt(valueOf)')
        .show('parseInt(toString)')
        .show('parseInt(testSequence)')
        .row()
        .show('Boolean(new Boolean(false))')
        .row()
        .show('+true')
        .show('-false')
        .row()
        .show('5 + true')
        .show('true + true')
        .row()
        .show('1 + [1,2]')
        .show('1+{}')
        .show('1+{a:1}')
        .show('{a: 1} + 1','primary')
        .show('({a: 1}) + 1')
        .row()
        .log('[]+[]')
        .show('[]+{}')
        .show('{} + []')
        .show('({}) + []')
        .show('{} + {}')
        .show('({}) + {}')
        .show('({} + {})')
        .log('var testConvert = {} + {}')
        .show('testConvert')
        .row()
        .show('parseFloat("3.14")')
        .show('parseFloat("314e-2")')
        .show('parseFloat("0.0314E+2")')
        .show('parseFloat("3.14more no-digit characters")')
        .row()
        .show('parseFloat("\\t\\v\\r3.14\\n")')
        .show('parseFloat("\\r\\v\\n3.14\\t")')
        .show('parseFloat("String")')
        .show('parseFloat("String555.88")')
        .show('Number("")')
        .row()
        .show('parseFloat(true)')
        .show('parseInt(true)')
        .show('Number(true)')
        .row()
        .show('parseInt(null)')
        .show('parseFloat(null)')
        .show('Number(null)')
        .row()
        .show('parseInt("")')
        .show('parseFloat("")')
        .show('Number("")')
        .row()
        .show('parseInt("123.45#")')
        .show('parseFloat("123.45#")')
        .show('Number("123.45#")')


    // don't work
//        .header('data type conversion')
//        .show('')
//                .show('object.valueOf()')
//    (function () {
//        var mya = {a: 1};
//        var valueOf = {valueOf: function () {
//            return 2;
//        }};
//        var toString = {toString: function () {
//            return 3;
//        }};
//        $('.javascript-exercise')
//            .header('data type conversion')
//            .show('mya')
////            .show('testOf')
////            .show('toString')
//    }());
    $('.javascript-exercise').find('>*').css('display', 'none');
    $('.head').on('click', 'div', function () {
        $('.javascript-exercise').find('>*').css('display', 'none');
        var target = '.' + this.className.replace(/h-/,'');
        $('.javascript-exercise').find(target).css('display','block').nextUntil('p.h').css('display', 'inline-block');
        //             test = $('.javascript-exercise').find(target);
//            console.log($('.javascript-exercise').find(target).nextUntil('p'));
//            test.css('display', 'inline-block');
    });
});
