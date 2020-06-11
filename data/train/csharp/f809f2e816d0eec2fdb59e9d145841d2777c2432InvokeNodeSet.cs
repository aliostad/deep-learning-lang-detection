using System.Collections.Generic;

namespace Pattern.Node
{
    /// <summary>
    /// InvokeNode的具体实现，使用HashSet保存子节点
    /// 调用模式参考InvokeNode的注释
    /// </summary>   
    public class InvokeNodeSet : InvokeNode
    {
        protected HashSet<InvokeNode> m_ChildNodes;

        public override int ChildCount
        {
            get { return m_ChildNodes.Count; }
        }

        public InvokeNodeSet()
        {
            m_ChildNodes = new HashSet<InvokeNode>();
            m_Name = string.Empty;
        }

        protected override void DetachChild(InvokeNode childNode)
        {
            m_ChildNodes.Remove(childNode);
        }

        protected override void AttachChild(InvokeNode childNode)
        {
            m_ChildNodes.Add(childNode);
        }

        public override IEnumerator<InvokeNode> GetEnumerator()
        {
            return m_ChildNodes.GetEnumerator();
        }

        public override void DetachChildren()
        {
            List<InvokeNode> tempNodes = new List<InvokeNode>(ChildCount);
            var enumerator = m_ChildNodes.GetEnumerator();
            while (enumerator.MoveNext())
            {
                tempNodes.Add(enumerator.Current);
            }

            for (var i = 0; i < tempNodes.Count; i++)
            {
                tempNodes[i].ParentNode = null;
            }
        }

        public override bool IsChildOf(InvokeNode parent)
        {
            InvokeNode tempNode = this;
            while (tempNode != null)
            {
                if (tempNode == parent)
                {
                    return true;
                }
                tempNode = tempNode.ParentNode;
            }
            return false;
        }

        /// <summary>
        /// 由于子节点使用HashSet，Find如果有同名路径，可能得到不稳定的值
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public override InvokeNode Find(string name)
        {
            if (name == null)
            {
                return null;
            }

            string[] names = name.Split('/');
            return FindNode(names, 0);
        }

        /// <summary>
        /// 由于子节点使用HashSet，FindNode如果有同名路径，可能得到不稳定的值
        /// </summary>
        /// <param name="names"></param>
        /// <param name="layerIndex"></param>
        /// <returns></returns>
        public override InvokeNode FindNode(string[] names, int layerIndex)
        {
            var enumerator = m_ChildNodes.GetEnumerator();
            while (enumerator.MoveNext())
            {
                if (enumerator.Current.Name != names[layerIndex])
                    continue;

                if (layerIndex == names.Length - 1)
                {
                    return enumerator.Current;
                }

                var targetNode = enumerator.Current.FindNode(names, layerIndex + 1);
                if (targetNode != null)
                {
                    return targetNode;
                }
            }
            return null;
        }

        public override void Invoke()
        {
            if (m_ChildNodes.Count == 0)
            {
                InvokeEvent.Invoke();
                return;
            }

            switch (NodeInvokeMode)
            {
                case InvokeMode.TreeDownToTop:
                case InvokeMode.TreeTopToDown:
                case InvokeMode.TreeReverseTopToDown:
                case InvokeMode.TreeReverseDownToTop:
                    InvokeTreeMode();
                    break;

                case InvokeMode.LayerTopToDown:
                case InvokeMode.LayerReverseTopToDown:
                    InvokeLayerTopToDown();
                    break;

                case InvokeMode.LayerDownToTop:
                case InvokeMode.LayerReverseDownToTop:
                    InvokeLayerDownToTop();
                    break;
            }
        }

        protected virtual void InvokeTreeMode()
        {
            if (NodeInvokeMode == InvokeMode.TreeTopToDown || NodeInvokeMode == InvokeMode.TreeReverseTopToDown)
            {
                InvokeEvent.Invoke();
            }

            var enumerator = m_ChildNodes.GetEnumerator();
            while (enumerator.MoveNext())
            {
                if(enumerator.Current.EnableSelf)
                    enumerator.Current.Invoke();
            }

            if (NodeInvokeMode == InvokeMode.TreeDownToTop || NodeInvokeMode == InvokeMode.TreeReverseDownToTop)
            {
                InvokeEvent.Invoke();
            }
        }

        protected virtual void InvokeLayerTopToDown()
        {
            Queue<InvokeNode> invokeNodes = new Queue<InvokeNode>(m_ChildNodes.Count + 1);
            invokeNodes.Enqueue(this);

            while (invokeNodes.Count > 0)
            {
                var invokeNode = invokeNodes.Dequeue();
                var enumerator = invokeNode.GetEnumerator();

                if (invokeNode.NodeInvokeMode == InvokeMode.LayerTopToDown || invokeNode.NodeInvokeMode == InvokeMode.LayerReverseTopToDown)
                {
                    while (enumerator.MoveNext())
                    {
                        if (enumerator.Current.EnableSelf)
                            invokeNodes.Enqueue(enumerator.Current);
                    }
                }

                if (invokeNode.NodeInvokeMode == InvokeMode.LayerTopToDown || invokeNode.NodeInvokeMode == InvokeMode.LayerReverseTopToDown)
                {
                    invokeNode.InvokeEvent.Invoke();
                }
                else
                {
                    invokeNode.Invoke();
                }
            }
        }

        protected virtual void InvokeLayerDownToTop()
        {
            var count = m_ChildNodes.Count + 1;
            Queue<InvokeNode> invokeNodes = new Queue<InvokeNode>(count);
            Stack<InvokeNode> invokeOrderNodes = new Stack<InvokeNode>(count);
            invokeNodes.Enqueue(this);

            while (invokeNodes.Count > 0)
            {
                var invokeNode = invokeNodes.Dequeue();
                invokeOrderNodes.Push(invokeNode);
                var enumerator = invokeNode.GetEnumerator();

                if (invokeNode.NodeInvokeMode == InvokeMode.LayerDownToTop || invokeNode.NodeInvokeMode == InvokeMode.LayerReverseDownToTop)
                {
                    while (enumerator.MoveNext())
                    {
                        if (enumerator.Current.EnableSelf)
                            invokeNodes.Enqueue(enumerator.Current);
                    }
                }
            }

            while (invokeOrderNodes.Count > 0)
            {
                var invokeNode = invokeOrderNodes.Pop();
                if (invokeNode.NodeInvokeMode == InvokeMode.LayerDownToTop || invokeNode.NodeInvokeMode == InvokeMode.LayerReverseDownToTop)
                {
                    invokeNode.InvokeEvent.Invoke();
                }
                else
                {
                    invokeNode.Invoke();
                }
            }
        }
    }
}
