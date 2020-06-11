using System.Collections.Generic;

namespace Pattern.Node
{
    /// <summary>
    /// InvokeNode的具体实现，使用List保存子节点，添加了子节点相关操作函数
    /// 调用模式参考InvokeNode的注释
    /// </summary>
    public class InvokeNodeList : InvokeNode
    {
        protected List<InvokeNode> m_ChildNodes;

        public virtual InvokeNode this[int index]
        {
            get { return m_ChildNodes[index]; }
        }

        public override int ChildCount
        {
            get { return m_ChildNodes.Count; }
        }

        public InvokeNodeList()
        {
            m_ChildNodes = new List<InvokeNode>(0);
            m_Name = string.Empty;
        }

        protected override void DetachChild(InvokeNode childNode)
        {
            var index = m_ChildNodes.LastIndexOf(childNode);
            if (index > -1)
            {
                m_ChildNodes.RemoveAt(index);
            }
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
            for (var i = ChildCount - 1; i >= 0; --i)
            {
                m_ChildNodes[i].ParentNode = null;
            }
        }

        public override InvokeNode Find(string name)
        {
            if (name == null)
            {
                return null;
            }

            string[] names = name.Split('/');
            return FindNode(names, 0);
        }

        public override InvokeNode FindNode(string[] names, int layerIndex)
        {
            for (var i = 0; i < m_ChildNodes.Count; ++i)
            {
                if (m_ChildNodes[i].Name != names[layerIndex])
                    continue;

                if (layerIndex == names.Length - 1)
                {
                    return m_ChildNodes[i];
                }

                var targetNode = m_ChildNodes[i].FindNode(names, layerIndex + 1);
                if (targetNode != null)
                {
                    return targetNode;
                }
            }
            return null;
        }

        public virtual InvokeNode GetChild(int index)
        {
            if (index < 0 || index >= m_ChildNodes.Count)
            {
                return null;
            }
            return m_ChildNodes[index];
        }

        public virtual int GetSiblingIndex()
        {
            if (mParentNode is InvokeNodeList)
            {
                var invokeNodeList = mParentNode as InvokeNodeList;
                return invokeNodeList.m_ChildNodes.IndexOf(this);
            }
            return -1;
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

        public virtual bool SetAsFirstSibling()
        {
            if (mParentNode is InvokeNodeList)
            {
                var parentNode = mParentNode as InvokeNodeList;
                int index = GetSiblingIndex();
                var targetNode = parentNode.m_ChildNodes[index];
                for (var i = index - 1; i >= 0; --i)
                {
                    parentNode.m_ChildNodes[i + 1] = parentNode.m_ChildNodes[i];
                }
                parentNode.m_ChildNodes[0] = targetNode;
                return true;
            }
            return false;
        }

        public virtual bool SetAsLastSibling()
        {
            var parentNode = mParentNode as InvokeNodeList;
            if (parentNode != null)
            {
                int index = GetSiblingIndex();
                var targetNode = parentNode.m_ChildNodes[index];
                parentNode.m_ChildNodes.RemoveAt(index);
                parentNode.m_ChildNodes.Add(targetNode);
                return true;
            }
            return false;
        }

        public virtual bool SetSiblingIndex(int index)
        {
            var parentNode = mParentNode as InvokeNodeList;
            if (parentNode != null)
            {
                if (index < 0 || index >= parentNode.m_ChildNodes.Count)
                {
                    return false;
                }

                int srcIndex = GetSiblingIndex();
                if (index < srcIndex)
                {
                    var targetNode = parentNode.m_ChildNodes[srcIndex];
                    for (var i = srcIndex - 1; i >= index; --i)
                    {
                        parentNode.m_ChildNodes[i + 1] = parentNode.m_ChildNodes[i];
                    }
                    parentNode.m_ChildNodes[index] = targetNode;
                }
                else if (index > srcIndex)
                {
                    var targetNode = parentNode.m_ChildNodes[srcIndex];
                    for (var i = srcIndex; i < index; ++i)
                    {
                        parentNode.m_ChildNodes[i] = parentNode.m_ChildNodes[i + 1];
                    }
                    parentNode.m_ChildNodes[index] = targetNode;
                }
                return true;
            }
            return false;
        }

        public override void Invoke()
        {
            if (!EnableSelf)
            {
                return;
            }

            if (m_ChildNodes.Count == 0)
            {
                InvokeEvent.Invoke();
                return;
            }

            switch (NodeInvokeMode)
            {
                case InvokeMode.TreeDownToTop:
                case InvokeMode.TreeTopToDown:
                    InvokeTreeMode();
                    break;

                case InvokeMode.TreeReverseTopToDown:
                case InvokeMode.TreeReverseDownToTop:
                    InvokeTreeReverseMode();
                    break;

                case InvokeMode.LayerTopToDown:
                    InvokeLayerTopToDown();
                    break;

                case InvokeMode.LayerDownToTop:
                    InvokeLayerDownToTop();
                    break;

                case InvokeMode.LayerReverseTopToDown:
                    InvokeLayerReverseTopToDown();
                    break;

                case InvokeMode.LayerReverseDownToTop:
                    InvokeLayerReverseDownToTop();
                    break;
            }
        }

        protected virtual void InvokeTreeMode()
        {
            if (NodeInvokeMode == InvokeMode.TreeTopToDown)
            {
                InvokeEvent.Invoke();
            }

            for (var i = 0; i < m_ChildNodes.Count; i++)
            {
                if(m_ChildNodes[i].EnableSelf)
                    m_ChildNodes[i].Invoke();
            }

            if (NodeInvokeMode == InvokeMode.TreeDownToTop)
            {
                InvokeEvent.Invoke();
            }
        }

        protected virtual void InvokeTreeReverseMode()
        {
            if (NodeInvokeMode == InvokeMode.TreeReverseTopToDown)
            {
                InvokeEvent.Invoke();
            }

            for (var i = m_ChildNodes.Count - 1; i >= 0; --i)
            {
                if (m_ChildNodes[i].EnableSelf)
                    m_ChildNodes[i].Invoke();
            }

            if (NodeInvokeMode == InvokeMode.TreeReverseDownToTop)
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

                if (invokeNode.NodeInvokeMode == InvokeMode.LayerTopToDown)
                {
                    while (enumerator.MoveNext())
                    {
                        if (enumerator.Current.EnableSelf)
                            invokeNodes.Enqueue(enumerator.Current);
                    }
                }

                if (invokeNode.NodeInvokeMode == InvokeMode.LayerTopToDown)
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

                if (invokeNode.NodeInvokeMode == InvokeMode.LayerDownToTop)
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
                if (invokeNode.NodeInvokeMode == InvokeMode.LayerDownToTop)
                {
                    invokeNode.InvokeEvent.Invoke();
                }
                else
                {
                    invokeNode.Invoke();
                }
            }
        }

        protected virtual void InvokeLayerReverseTopToDown()
        {
            var count = m_ChildNodes.Count + 1;
            Queue<InvokeNode> invokeNodes = new Queue<InvokeNode>(count);
            Stack<InvokeNode> invokeReverseOrderNodes = new Stack<InvokeNode>(count);
            invokeNodes.Enqueue(this);

            while (invokeNodes.Count > 0)
            {
                var invokeNode = invokeNodes.Dequeue();
                var enumerator = invokeNode.GetEnumerator();

                if (invokeNode.NodeInvokeMode == InvokeMode.LayerReverseTopToDown)
                {
                    while (enumerator.MoveNext())
                    {
                        if (enumerator.Current.EnableSelf)
                            invokeReverseOrderNodes.Push(enumerator.Current);
                    }
                }

                while (invokeReverseOrderNodes.Count > 0)
                {
                    invokeNodes.Enqueue(invokeReverseOrderNodes.Pop());
                }

                if (invokeNode.NodeInvokeMode == InvokeMode.LayerReverseTopToDown)
                {
                    invokeNode.InvokeEvent.Invoke();
                }
                else
                {
                    invokeNode.Invoke();
                }
            }
        }

        protected virtual void InvokeLayerReverseDownToTop()
        {
            var count = m_ChildNodes.Count + 1;
            Queue<InvokeNode> invokeNodes = new Queue<InvokeNode>(count);
            Stack<InvokeNode> invokeOrderNodes = new Stack<InvokeNode>(count);
            Stack<InvokeNode> invokeReverseOrderNodes = new Stack<InvokeNode>(count);
            invokeNodes.Enqueue(this);

            while (invokeNodes.Count > 0)
            {
                var invokeNode = invokeNodes.Dequeue();
                invokeOrderNodes.Push(invokeNode);
                var enumerator = invokeNode.GetEnumerator();

                if (invokeNode.NodeInvokeMode == InvokeMode.LayerReverseDownToTop)
                {
                    while (enumerator.MoveNext())
                    {
                        if (enumerator.Current.EnableSelf)
                            invokeReverseOrderNodes.Push(enumerator.Current);
                    }
                }

                while (invokeReverseOrderNodes.Count > 0)
                {
                    invokeNodes.Enqueue(invokeReverseOrderNodes.Pop());
                }
            }

            while (invokeOrderNodes.Count > 0)
            {
                var invokeNode = invokeOrderNodes.Pop();
                if (invokeNode.NodeInvokeMode == InvokeMode.LayerReverseDownToTop)
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
