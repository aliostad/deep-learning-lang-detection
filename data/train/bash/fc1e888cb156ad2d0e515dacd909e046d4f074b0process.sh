思考题：
    从加电到 操作系统运行 出现界面 所做的一切事情。。。
    编写一个程序    直接 从启动 出现 hello world 直接关机


进程管理
    Process
        What is process??   
            A process is an instance of a computer program that is being 
            executed. It contains the program code and its current activity
            例如： 同时打开 多个浏览器的 窗口   每一个都是一个进程
        What is the difference between program and process ??
            Program is just the static text
            Process is an dynamic entiy being executed. and has lifecycle
        A process consists of threee parts
            Process Control Block (process table entry )
            Program (Text)
            Data

        Process Control Block
            process id 每一个进程都有一个自己的id
            parentpid
            block or...    进程的优先级
            进程状态
            寄存器      进程工作的环境  

            内存管理

            打开的文件信息  

        Process Tree
            父子进程  一直向下分

        进程状态
            创建进程
                系统开启时会自动创建一个进程  init
                init 进程又会 创建其他的进程 网络服务。。。
                fork  系统调用创建一个进程
                    返回值两个else  是两个进程
                    一个进程 执行一个里面的内容
            running
            就绪
            阻塞    等不到资源会睡觉  另一个占用这个资源的进程应该负责叫醒它
            调试状态    debug
            僵尸状态    

            



        
