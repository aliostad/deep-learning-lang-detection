/**
 *
 */
package org.apache.hadoop.hdfs.server.namenodeFBT.msg;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.hadoop.hdfs.server.namenodeFBT.utils.StringUtility;


/**
 * @author hanhlh
 *
 */
public class MessageHandlerMap {

// instance attributes ////////////////////////////////////////////////////

    /**
     * <p>��å������ϥ�ɥ����Ͽ����ơ��֥�Ǥ����ϥ�ɥ� ID ʸ�����
     * �����ͤȤ��ơ��ϥ�ɥ��ޥåפ��ͤ��ݻ�ޤ���</p>
     * <String,MessageHandler>
     */
    private Map<String, MessageHandler> _mhandlers;

    /**
     * <p>�ǥե���ȤΥ�å������ϥ�ɥ�Ǥ����б������å������ϥ�ɥ餬
     * ��Ͽ����Ƥ��ʤ��Ȥ��˻��Ѥ���ޤ���</p>
     */
    private MessageHandler _defaultHandler;

    // constructors ///////////////////////////////////////////////////////////

    /**
     * DefaultHandler�Ȥ���NullHandler�����Ѥ����å������ϥ�ɥ��б�ɽ��
     * �������ޤ���
     */
    public MessageHandlerMap(){
        this(NullHandler.getInstance());
    }

    /**
     * ����ǻ��ꤵ�줿DefaultHandler�����Ѥ����å������ϥ�ɥ��б�ɽ��
     * �������ޤ���
     */
    public MessageHandlerMap(MessageHandler _defaultHandler) {
        super();
        _mhandlers = new ConcurrentHashMap<String, MessageHandler>();
        setDefaultHandler(_defaultHandler);
    }

    // accessors //////////////////////////////////////////////////////////////

    /**
     * ����ǻ��ꤵ�줿handlerID���б�����MessageHandler�ؤλ��Ȥ��֤��ޤ���
     * @param handlerID ʸ����Ǥ���蘆���handlerID.
     * @return handlerID���б��դ���줿MessageHandler
     */
    public MessageHandler getHandler(String handlerID) {
    	//StringUtility.debugSpace("MessageHanderMap.getHandler");
        if (handlerID == null){
            return _defaultHandler;
        }
        //synchronized(_mhandlers) {
        	MessageHandler handler = _mhandlers.get(handlerID);

        	return (handler == null) ? _defaultHandler : handler;
        //}
    }

    /**
     * <p> ����ǻ��ꤵ�줿 Message Handler �� default �� Handler �Ȥ�
     * �����Ѥ��ޤ���</p>
     *
     * <p> DefaultHandler �ϡ��б������å������ϥ�ɥ餬��Ͽ����Ƥ��ʤ��Ȥ���
     * ���Ѥ���ޤ���</p>
     * @param defaultHandler
     */
    public void setDefaultHandler(MessageHandler defaultHandler) {
        _defaultHandler = defaultHandler;
    }

    // instance methods ///////////////////////////////////////////////////////

    /**
     * <p> ����ǻ��ꤵ�줿 handlerID ���б����� �ϥ�ɥ�Ȥ��ơ�
     * handler ����Ͽ���ޤ��� </p>
     *
     * <p> �����null����ꤷ�ƤϤ����ޤ��� </p>
     *
     * @param handlerID �����Ȥʤ�ʸ����
     * @param handler �б����� MessageHandler
     * @exception IllegalArgumentException ����� null ����ꤷ���Ȥ��֤�ޤ���
     */
    public void addHandler(String handlerID, MessageHandler handler) {
    	//StringUtility.debugSpace("MessageHanderMap.addHandler");
        if (handlerID == null || handler == null) {
            throw new IllegalArgumentException("null argument");
        }
        //synchronized (_mhandlers) {
        	_mhandlers.put(handlerID, handler);
        //}
    }

    /**
     * <p> ����ǻ��ꤵ�줿 handlerID ���б��դ��򤳤�Map������ޤ���</p>
     *
     * <p> �����null����ꤷ�ƤϤ����ޤ��� </p>
     * @param handlerID �б��դ������ʸ����
     * @exception IllegalArgumentException ����� null ����ꤷ���Ȥ�������ޤ���
     */
    public void removeHandler(String handlerID) {
    	//StringUtility.debugSpace("MessageHanderMap.removeHandler");
        if (handlerID == null){
            throw new IllegalArgumentException("null argument");
        }
        //synchronized (_mhandlers) {
        	_mhandlers.remove(handlerID);
        //}
    }

}
