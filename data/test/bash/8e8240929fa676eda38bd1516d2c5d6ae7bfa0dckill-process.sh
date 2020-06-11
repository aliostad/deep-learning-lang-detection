#!/bin/bash
# kill-proces.s;    使用pidof 命令帮忙Kill一个进程

NOPROCESS=2
process=xxxyyyzzz       # 使用不存在的进程 
# 只不过是为了演示。
# ...并不想在这个脚本中杀掉任何真正的进行。
# 举个例子，如果你想使用这个脚本来断线internet,
# process=pppd

t=`pidof $process`      # 取得$process的pid(f进程id)
# 'kill'只能使用pid(不能用程序名)作为参数。
if [[ -z $t ]]; then        # 如果没有这个进程，'pidof‘返回空
    echo "Process $process was not running."
    echo "Nothhing killed."
    exit $NOPROCESS
fi

kill $t                     # 对于某些顽固的进程可能需要使用’klll -9'.

# 这里需要做一个检查，看看二重唱 否允许自身被kill
# 或许另一个't=`pidof $process`' 或者...

# 整个脚本都可以使用下边这名来替换：
# kill $(pidof -x process_name)
# 或者
# killall process_name
# 但这就没有教育意义了。

exit 0
