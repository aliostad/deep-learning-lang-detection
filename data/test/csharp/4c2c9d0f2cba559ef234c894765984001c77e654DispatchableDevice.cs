// ***********************************************************************
// 作者           : shuaihong617@qq.com
// 创建           : 2016-10-30
//
// 编辑           : shuaihong617@qq.com
// 日期           : 2016-11-11
// 内容           : 创建文件
// ***********************************************************************
// Copyright (c) 果壳机动----有金属的地方就有果壳. All rights reserved.
// <summary>
// </summary>
// ***********************************************************************

using Nutshell.Aspects.Locations.Contracts;
using Nutshell.Aspects.Locations.Propertys;
using Nutshell.Automation.Models;
using Nutshell.Data;
using Nutshell.Extensions;
using System;
using Nutshell.Storaging;

namespace Nutshell.Automation
{
        /// <summary>
        ///         可调度组件
        /// </summary>
        public abstract class DispatchableDevice : ConnectableDevice, IStorable<DispatchableDeviceModel>
        {
                /// <summary>
                ///         初始化<see cref="DispatchableDevice" />的新实例.
                /// </summary>
                /// <param name="id">The identifier.</param>
                protected DispatchableDevice(string id = "")
                        : base(id)
                {
                        DispatchState = DispatchState.Terminated;
                }

                #region 字段

                /// <summary>
                ///         线程同步标识
                /// </summary>
                private readonly object _lockFlag = new object();

                #endregion 字段

                #region 属性

                /// <summary>
                ///         获取调度状态
                /// </summary>
                /// <value>调度状态</value>
                [NotifyPropertyValueChanged]
                public DispatchState DispatchState { get; private set; }

                #endregion 属性

                #region 存储

                /// <summary>
                ///         从数据模型加载数据
                /// </summary>
                /// <param name="model">读取数据的源数据模型，该数据模型不能为null</param>
                public void Load([MustNotEqualNull]DispatchableDeviceModel model)
                {
                        base.Load(model);
                }

                /// <summary>
                ///         保存数据到数据模型
                /// </summary>
                /// <param name="model">写入数据的目的数据模型，该数据模型不能为null</param>
                public void Save(DispatchableDeviceModel model)
                {
                        throw new NotImplementedException();
                }

                #endregion 存储

                /// <summary>
                ///         连接
                /// </summary>
                /// <returns>操作结果</returns>
                public Result StartDispatch()
                {
                        lock (_lockFlag)
                        {
                                lock (_lockFlag)
                                {
                                        if (ConnectState != ConnectState.Connected)
                                        {
                                                return Result.Failed;
                                        }

                                        if (DispatchState == DispatchState.Established)
                                        {
                                                return Result.Successed;
                                        }

                                        DispatchState = DispatchState.Establishing;

                                        if (!IsEnable)
                                        {
                                                this.Warn("未启用");

                                                DispatchState = DispatchState.Terminated;
                                                return Result.Failed;
                                        }

                                        var result = StartDispatchCore();

                                        DispatchState = result.IsSuccessed ? DispatchState.Established : DispatchState.Terminated;

                                        return result;
                                }
                        }
                }

                protected virtual Result StartDispatchCore()
                {
                        return Result.Successed;
                }

                /// <summary>
                ///         断开连接
                /// </summary>
                /// <returns>操作结果</returns>
                public Result StopDispatch()
                {
                        lock (_lockFlag)
                        {
                                if (DispatchState == DispatchState.Terminated)
                                {
                                        return Result.Successed;
                                }

                                DispatchState = DispatchState.Terminating;

                                if (!IsEnable)
                                {
                                        this.Warn("未启用");

                                        DispatchState = DispatchState.Terminated;
                                        return Result.Successed;
                                }

                                var result = StopDispatchCore();

                                DispatchState = DispatchState.Terminated;

                                return result;
                        }
                }

                protected virtual Result StopDispatchCore()
                {
                        return Result.Successed;
                }
        }
}