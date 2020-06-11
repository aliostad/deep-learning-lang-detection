package com.ibfw


/**
 * Actor 的使用
 * Scala的Actor类似于Java中的多线程编程。但是不同的是，Scala的Actor提供的模型与多线程有所不同。Scala的Actor尽可能地避免锁和共享状态，
 * 从而避免多线程并发时出现资源争用的情况，进而提升多线程编程的性能。此外，Scala Actor的这种模型还可以避免死锁等一系列传统多线程编程的问题。
 * 
 * Spark中使用的分布式多线程框架，是Akka。Akka也实现了类似Scala Actor的模型，其核心概念同样也是Actor。因此只要掌握了Scala Actor，
 * 那么在Spark源码研究时，至少即可看明白Akka Actor相关的代码。但是，换一句话说，由于Spark内部有大量的Akka Actor的使用，
 * 因此对于Scala Actor也至少必须掌握，这样才能学习Spark源码。
 *  1、Actor的创建、启动和消息收发（案例：Actor Hello World）
    2、收发case class类型的消息（案例：用户注册登录后台接口）
    3、Actor之间互相收发消息（案例：打电话）
    4、同步消息和Future
 * 
 */
object Test_Actor extends App{
  
//  Case1 Actor的创建、销毁、和收发消息
  // Scala提供了Actor trait来让我们更方便地进行actor多线程编程，就Actor trait就类似于Java中的Thread和Runnable一样，是基础的多线程基类和接口。我们只要重写Actor trait的act方法，即可实现自己的线程执行体，与Java中重写run方法类似。
// 此外，使用start()方法启动actor；使用!符号，向actor发送消息；actor内部使用receive和模式匹配接收消息

// 案例：Actor Hello World

  
/*  import scala.actors.Actor
  class HelloActor extends Actor{
    def act(){
      while (true) {
//        receive 接收消息
        receive {
          case  name:String => println("Hello , "+name)
        }
      }
    }
  }
  
  val helloActor = new HelloActor
//  启动线程
  helloActor.start()
//  “！”进行发送消息
  helloActor ! "jack"*/
  
  
//  Case2 收发case class的消息
    // Scala的Actor模型与Java的多线程模型之间，很大的一个区别就是，Scala Actor天然支持线程之间的精准通信；即一个actor可以给其他actor直接发送消息。这个功能是非常强大和方便的。
    // 要给一个actor发送消息，需要使用“actor ! 消息”的语法。在scala中，通常建议使用样例类，即case class来作为消息进行发送。然后在actor接收消息之后，可以使用scala强大的模式匹配功能来进行不同消息的处理。
    // 案例：用户注册登录后台接口
 
 /* import scala.actors.Actor
  
// Scala中提供了一种特殊的类，用case class进行声明，中文也可以称作样例类。case class其实有点类似于Java中的JavaBean的概念。即只定义field，并且由Scala编译时自动提供getter和setter方法，但是没有method。
// case class的主构造函数接收的参数通常不需要使用var或val修饰，Scala自动就会使用val修饰（但是如果你自己使用var修饰，那么还是会按照var来）
//  Scala自动为case class定义了伴生对象，也就是object，并且定义了apply()方法，该方法接收主构造函数中相同的参数，并返回case class对象
  case class Login(username:String,password:String)
  case class Register(username:String,password:String)
  class UserManageActor extends Actor{
    
    def act(){
      while(true){
        receive {
          case Login(username,password) => println("login, username is "+username+" , password is "+password)
          case Register(username,password) => println("register, username is "+username+" , password is "+password)
        }
      }
    }
  }
  
val userManageActor = new UserManageActor
userManageActor.start()
userManageActor ! Register("jack","123");userManageActor ! Login("jack","123")
  new Login("jj","111")*/
  
  
  
//  Case3 Actor之间互相收发消息
  // 如果两个Actor之间要互相收发消息，那么scala的建议是，一个actor向另外一个actor发送消息时，同时带上自己的引用；其他actor收到自己的消息时，直接通过发送消息的actor的引用，即可以给它回复消息。
// 案例：打电话
  /*import scala.actors.Actor
  
  case class Message(content:String,send:Actor)
  class TomTelephoneActor extends Actor{
//    act() 类似与java的run()方法
    def act(){
      while(true){
        receive {
          case Message(content,send) => println("TomTelephone receive :"+content) ;send ! "I'm tom ,please call me after 10 minutes."
        }
      }
      
    }
  }
  
  class JackTelephoneActor(val tomTelephoneActor:Actor)  extends Actor{
    def act(){
      tomTelephoneActor ! Message("jack say hello",this)
      receive {
        case respone:String =>println("JackTelephone receive "+respone)
      }
    }
  }

  val tom  = new TomTelephoneActor
  val jack = new JackTelephoneActor(tom)
  jack.start()
  tom.start()*/
  
  
  
//  Case4 同步消息和  Future
// 默认情况下，消息都是异步的；但是如果希望发送的消息是同步的，即对方接受后，一定要给自己返回结果，那么可以使用!?的方式发送消息。即val reply = actor !? message。
// 如果要异步发送一个消息，但是在后续要获得消息的返回值，那么可以使用Future。即!!语法。val future = actor !! message。val reply = future()。

    /*import scala.actors.Actor
  class HelloActor extends Actor{
    def act(){
//        receive 接收消息
        receive {
          
          case  name:String => println("Hello , "+name)
          1111
        }
        
    }
  }
  val actor =  new HelloActor
  actor.start()
  actor ! "iii" //异步发送
	actor !? "iii" //同步发送
  actor !! "iii" //异步后续得到返回值 Future
*/  
  


}