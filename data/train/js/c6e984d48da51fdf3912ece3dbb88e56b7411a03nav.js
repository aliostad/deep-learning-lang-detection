/* globals NAMESPACE */
/* eslint-disable fecs-camelcase */
/**
 * @file nav 组件
 * @author wanghongliang02
 */

$.widget('blend.nav', {
    /**
     * 组件的默认选项，可以由多重覆盖关系
     */
    options: {
        column: 3,
        animate: true,
        time: 500,
        expand: '<i>更多</i>',
        pack: '<i>收起</i>',
        itemClass: NAMESPACE + 'nav-item',
        row: false,
        rowHeight: 30
    },
    /**
     * _create 创建组件时调用一次
     */
    _create: function () {
        var nav = this;
        var $el = nav.element;
        nav.$items = $el.find('.' + nav.options.itemClass);

        nav.expandClass = NAMESPACE + 'nav-expand';
        nav.animateClass = NAMESPACE + 'nav-animation';
        nav.expandedClass = NAMESPACE + 'nav-expanded';
        nav.columnClassPre = NAMESPACE + 'nav-column-';
        nav.hideClass = NAMESPACE + 'nav-item-hide';
        nav.noborderClass = NAMESPACE + 'nav-item-no-border';
        nav.columnRange = [2, 3, 4, 5, 6];
        //
        nav.expandTaped = false;
    },
    /**
     * _init 初始化的时候调用
     */
    _init: function () {
        var nav = this;
        nav._setColumn();
        nav._setRow();

        FastClick.attach(nav.element[0]);
        /*
        setTimeout(function (){
            if (nav.options.animate) {
                nav.element.addClass(nav.animateClass);
            }
            else {
                nav.element.removeClass(nav.animateClass);
            }
        }, 100);
        */
        if (!nav.inited) {
            nav._initEvent();
            nav.inited = true;
        }
    },
    /**
     *
     * @private
     */
    _initEvent: function () {
        var nav = this;

        nav.element.on('click.nav', '.' + nav.expandClass, function (e) {
            nav.expandTaped = true;
            setTimeout(function (){
                nav.expandTaped = false;
            }, 500);
            /*
            if (!new RegExp(nav.expandClass).test(e.target.parentNode.className)){
                return ;
            }*/
            var $this = $(this);
            if ($this.hasClass(nav.expandedClass)) {
                var height = nav.$items.eq(0).height();
                
                if (nav.options.animate){
                    nav.element.animate({'height': height * nav.options.row}, 300, "ease-in");
                }else{
                    nav.element.css('height', height * nav.options.row);
                }
                
                var max = nav.options.row * nav.options.column;
                nav.$items.each(function (i) {
                    var $navItem = $(this);
                    if (i >= max - 1) {
                        if (nav.options.animate) {
                            setTimeout(function () {
                                $navItem.addClass(nav.hideClass);
                            }, nav.options.time);
                        }
                        else {
                            $navItem.addClass(nav.hideClass);
                        }
                    }
                    if (i >= max - nav.options.column) {
                        if (nav.options.animate) {
                            setTimeout(function () {
                                $navItem.addClass(nav.noborderClass);
                            }, nav.options.time);
                        }
                        else {
                            $navItem.addClass(nav.noborderClass);
                        }
                    } else {
                        if (nav.options.animate) {
                            setTimeout(function () {
                                $navItem.removeClass(nav.noborderClass);
                            }, nav.options.time);
                        }
                        else {
                            $navItem.removeClass(nav.noborderClass);
                        }
                    }
                });
                if (nav.options.animate) {
                    setTimeout(function () {
                        $this.html(nav.options.expand);
                        $this.removeClass(nav.expandedClass);
                    }, nav.options.time);
                }
                else {
                    $this.html(nav.options.expand);
                    $this.removeClass(nav.expandedClass);
                }
            }
            else {
                var len = nav.$items.length;
                var row = Math.ceil(len / nav.options.column) + (len % nav.options.column ? 0 : 1);
                height = nav.$items.eq(0).height() * row;
                if (nav.options.animate){
                    nav.element.animate({'height': height}, 300, "ease-in");
                }else{
                    nav.element.css('height', height);
                }

                $this.addClass(nav.expandedClass);
                
                nav.$items.removeClass(nav.hideClass);
                $this.html(nav.options.pack);
                var offset = len % nav.options.column || nav.options.column;
                var max = len - offset;
                nav.$items.each(function (i) {
                    var $this = $(this);
                    if (i >= max) {
                        $this.addClass(nav.noborderClass);
                    } else {
                        $this.removeClass(nav.noborderClass);
                    }
                });
            }
            if (nav.options.expandHandle && $.isFunction(nav.options.expandHandle)) {
                nav.options.expandHandle(e);
            }

        });

        nav.element.on('click.nav', "." + nav.options.itemClass, function (e){
            if (nav.expandTaped){
                e.preventDefault();
                return false;
            }
            
        });
    },
    /**
     * _setColumn 自定义的成员函数，
     * 所有以下划线开头的函数不可在外部调用
     */
    _setColumn: function () {
        var nav = this;
        var $el = nav.element;
        /**
         * 处理column范围
         */
        var columnNum = ($el[0].className).match(/blend\-nav\-column\-(\d{1})/);
        
        if (columnNum){
            nav.options.column = parseInt(columnNum[1], 10);
        }
        
        if (nav.options.column && $.inArray(nav.options.column, nav.columnRange) === -1) {
            nav.options.column = 3;
        }
        var columnClass = [];
        for (var i = 0; i < nav.columnRange.length; i++) {
            columnClass.push(nav.columnClassPre + nav.columnRange[i]);
        }
        $el.removeClass(columnClass.join(' ')).addClass(nav.columnClassPre + nav.options.column);
    },
    /**
     * _setRow 自定义的成员函数，
     * @private
     */
    _setRow: function () {
        var nav = this;
        var option = nav.options;
        if (option.row === false) {
            nav._removeExpand();
            return;
        }
        option.row = parseInt(option.row, 10);
        if (option.row < 1) {
            option.row = false;
            nav._removeExpand();
            return;
        }

        var length = nav.$items.length;
        var max = option.column * option.row;
        if (max >= length) {
            nav._removeExpand();
            return;
        }
        nav._addExpand(max);
    },
    /**
     * remove expand
     * @private
     */
    _removeExpand: function () {
        var nav = this;
        var option = nav.options;
        var $el = nav.element;
        var len = nav.$items.length;
        var row = Math.ceil(len / nav.options.column);
        var rowHeight = nav.$items.eq(0).height() > 0 ? nav.$items.eq(0).height() : option.rowHeight;
        var height = rowHeight * row ;
        $el.css('height', height);
        $el.find('.' + nav.expandClass).remove();
        nav.$items.removeClass(this.hideClass);
        var max = (option.column - 1) * option.row;
        nav.$items.each(function (i) {
            var $this = $(this);
            if (i >= max) {
                $this.addClass(nav.noborderClass);
            } else {
                $this.removeClass(nav.noborderClass);
            }
        });
    },
    /**
     * @param {number} max 最大行数
     * @private
     */
    _addExpand: function (max) {
        var nav = this;
        var option = nav.options;
        nav.$items.each(function (i) {
            var $this = $(this);
            if (i >= max - nav.options.column) {
                $this.addClass(nav.noborderClass);
            } else {
                $this.removeClass(nav.noborderClass);
            }
            if (i >= max - 1) {
                $this.addClass(nav.hideClass);
            }
            else {
                $this.removeClass(nav.hideClass);
            }
        });
        //var height = nav.$items.eq(0).height();
        var height = nav.$items.eq(0).height() > 0 ? nav.$items.eq(0).height() : option.rowHeight;
        
        nav.element.css('height', height * nav.options.row);
        if (nav.element.find('.' + nav.expandClass).length === 1) {
            nav.element.find('.' + nav.expandClass).removeClass(nav.expandedClass).html(nav.options.expand);
        }
        else {
            nav.element.append('<span class="' +
                nav.options.itemClass + ' ' + nav.expandClass + '">' + nav.options.expand + '</span>');
        }
    },
    /**
     * 销毁对象
     * @private
     */
    _destroy: function () {
        var nav = this;
        nav.options.row = false;
        nav._removeExpand();
        nav.element.off('click.nav', '.' + nav.expandClass);
    }
});
