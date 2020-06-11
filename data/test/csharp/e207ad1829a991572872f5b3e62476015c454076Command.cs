using System;
using System.Collections.Generic;
using System.Text;

namespace GCL.Bean.Transaction {

    /// <summary>
    /// 主要用于处理事务步骤
    /// </summary>
    public class Command {
        //真实调用的对象
        private object o;
        private string invokeMethod;
        private object[] invokeParas;

        private string rollbackMethod;
        private object[] rollbackParas;
        private InvokeOrder order;

        /// <summary>
        /// 请注意如果需要前面执行的Command结果作为后面Command的参数，请加入invokeParas\rollbackParas中，不会二次调用，而且默认的Rollback方法第一个参数是method方法的结果
        /// </summary>
        /// <param name="o"></param>
        /// <param name="method"></param>
        /// <param name="invokeParas"></param>
        /// <param name="order"></param>
        /// <param name="rollbackMethod"></param>
        public Command(object o, string method, object[] invokeParas, InvokeOrder order, string rollbackMethod) {
            if (o == null)
                throw new InvalidOperationException("操作对象不能为空!");
            if (!GCL.Common.Tool.IsEnable(method))
                throw new InvalidOperationException("调用对象方法不能为空!");
            this.o = o;
            this.invokeMethod = method;
            this.invokeParas = invokeParas;
            this.order = order;
            this.rollbackMethod = rollbackMethod;
            this.rollbackParas = new object[((invokeParas != null && invokeParas.Length > 0) ? invokeParas.Length : 0) + 1];
            rollbackParas[0] = this;
            if (invokeParas != null && invokeParas.Length > 0)
                Array.Copy(invokeParas, 0, rollbackParas, 1, invokeParas.Length);
        }

        /// <summary>
        /// 请注意如果需要前面执行的Command结果作为后面Command的参数，请加入invokeParas\rollbackParas中，不会二次调用，而且默认的Rollback方法第一个参数是method方法的结果
        /// </summary>
        /// <param name="o"></param>
        /// <param name="method"></param>
        /// <param name="invokeParas"></param>
        /// <param name="order"></param>
        public Command(object o, string method, object[] invokeParas, InvokeOrder order)
            : this(o, method, invokeParas, order, null) {
        }

        /// <summary>
        /// 请注意如果需要前面执行的Command结果作为后面Command的参数，请加入invokeParas\rollbackParas中，不会二次调用，而且默认的Rollback方法第一个参数是method方法的结果
        /// </summary>
        /// <param name="o"></param>
        /// <param name="method"></param>
        /// <param name="order"></param>
        /// <param name="rollbackMethod"></param>
        public Command(object o, string method, InvokeOrder order, string rollbackMethod) : this(o, method, null, order, rollbackMethod) { }

        protected virtual object Invoke(object o, string invokeMethod, object[] invokeParas) {
            return GCL.Bean.BeanTool.Invoke(o, invokeMethod, invokeParas);
        }

        private object r;

        /// <summary>
        /// 结果
        /// </summary>
        public object Result {
            get { return r; }
        }

        private bool hasAction = false;
        /// <summary>
        /// 是否已经成功提交
        /// </summary>
        public bool HasAction {
            get { return hasAction; }
        }

        /// <summary>
        /// 表示是否提交
        /// </summary>
        private bool actioned = false;
        /// <summary>
        /// 执行
        /// </summary>
        internal virtual void Action() {
            if (this.hasAction)
                return;
            this.actioned = true;
            object[] paras = new object[invokeParas != null ? invokeParas.Length : 0];
            for (int w = 0; w < paras.Length; w++)
                if (invokeParas[w] is Command) {
                    Command c = ((Command)invokeParas[w]);
                    c.Action();
                    paras[w] = c.Result;
                } else
                    paras[w] = invokeParas[w];
            Invoke(o, this.invokeMethod, paras);
            this.hasAction = true;
        }

        /// <summary>
        /// 回滚
        /// </summary>
        internal virtual void RollBack() {
            if (!this.actioned || !GCL.Bean.BeanTool.IsEnable(this.rollbackMethod))
                return;

            if (this.HasAction)
                Invoke(o, this.rollbackMethod, this.rollbackParas);

            for (int w = this.rollbackParas.Length - 1; w > 0; w--)
                if (invokeParas[w] is Command) {
                    Command c = (Command)rollbackParas[w];
                    if (c.HasAction)
                        try {
                            c.RollBack();
                        } catch {
                        }
                }
        }

        enum InvokeEnum {
            Action,
            RollBack
        }
    }
}
