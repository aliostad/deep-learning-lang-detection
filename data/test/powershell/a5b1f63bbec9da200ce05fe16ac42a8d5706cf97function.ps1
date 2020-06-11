# 当前目录下创建一个 package
function mk-package {
    $file = 'G:\package.json';

    Param($nodeModule, $save);
    $cur = (Get-Item -Path './').FullName;
    Copy-Item $file $cur;

    if ($nodeModule) {
        if (!$save) {
            $save = '-S';
        }

        npm i $nodeModule $save;
    }
}

# 删除目录
function ddir {
    Remove-Item $args[0] -R -Force
}

# 获取当前目录下的所有包含指定字符的目录、文件
#  例： jget-all jquery
function jget-all {
    Param($filter);
    $filter = '*' + $filter + '*';
    (ls).Where({$_.Name -like $filter})
}

# 获取当前目录下的所有包含指定字符的目录
function jget-dir {
    jget-all($args[0]) | ? {Test-Path $_.Name -PathType container}
}

# 获取当前目录下的所有包含指定字符的文件
function jget-file {
    jget-all($args[0]) | ? {Test-Path $_.Name -PathType leaf}
}

# 查看指定扩展名的文件
#    例： jget-ext js
function jget-ext {
    Param($ext);
    $ext = '*' + $ext;
    (ls).Where({$_.Extension -like $ext});
}


# 进入指定字符的目录，通常用于目录较长的情况

function jcd {
    Param($filter, $order);
    $order = [int]$order;
    cd (jget-dir $filter)[$order];
}

# 忽略
#   express 启动快键方式
function ex {
    Param($debug);
    if (!$debug) {
        $debug = 'myapp,myapp:server';
    }
    $env:DEBUG=$debug;
    node bin/www;
}