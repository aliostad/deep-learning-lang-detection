
//  DispatchFactory.cs
//  Nilsen
//  2015-04-05
//using System;

//namespace NetWrapper.Network
//{

//    public abstract class DispatchFactoryBase
//    {
//        public abstract Dispatch Create(ISession session);    //创建
//        public abstract void Destory(Dispatch dispatch);    //释放
//    }

//    /// <summary>
//    /// 分派类工厂
//    /// </summary>
//    public class DispatchFactory<T> : DispatchFactoryBase
//        where T : Dispatch, new()
//    {

//        /// <summary>
//        /// 创建
//        /// </summary>
//        /// <param name="session"></param>
//        /// <returns></returns>
//        public override Dispatch Create(ISession session)
//        {
//            T t = new T();
//            t.SetSession(session);
//            return t;
//        }

//        /// <summary>
//        /// 释放
//        /// </summary>
//        /// <param name="dispatch"></param>
//        public override void Destory(Dispatch dispatch)
//        {
//            return;
//        }
//    }
//}