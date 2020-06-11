/*
 * This class was automatically generated with 
 * <a href="http://castor.exolab.org">Castor 0.9.4</a>, using an
 * XML Schema.
 * $Id$
 */

package com.ai.partybuild.protocol.greenHouse.greenHouse103.rsp;

  //---------------------------------/
 //- Imported classes and packages -/
//---------------------------------/

import java.io.Reader;
import java.io.Serializable;
import java.io.Writer;
import java.util.Enumeration;
import java.util.Vector;

import com.ai.commonframe.jsonmodel.core.IBody;

/**
 * 
 * 
 * @version $Revision$ $Date$
**/
public class ManageInfos extends IBody implements java.io.Serializable {


      //--------------------------/
     //- Class/Member Variables -/
    //--------------------------/

    private java.util.Vector _manageInfoList;


      //----------------/
     //- Constructors -/
    //----------------/

    public ManageInfos() {
        super();
        _manageInfoList = new Vector();
    } //-- com.ai.partybuild.protocol.greenHouse.greenHouse103.rsp.ManageInfos()


      //-----------/
     //- Methods -/
    //-----------/

    /**
     * 
     * 
     * @param vManageInfo
    **/
    public void addManageInfo(ManageInfo vManageInfo)
        throws java.lang.IndexOutOfBoundsException
    {
        _manageInfoList.addElement(vManageInfo);
    } //-- void addManageInfo(ManageInfo) 

    /**
     * 
     * 
     * @param index
     * @param vManageInfo
    **/
    public void addManageInfo(int index, ManageInfo vManageInfo)
        throws java.lang.IndexOutOfBoundsException
    {
        _manageInfoList.insertElementAt(vManageInfo, index);
    } //-- void addManageInfo(int, ManageInfo) 

    /**
    **/
    public java.util.Enumeration enumerateManageInfo()
    {
        return _manageInfoList.elements();
    } //-- java.util.Enumeration enumerateManageInfo() 

    /**
     * 
     * 
     * @param index
    **/
    public ManageInfo getManageInfo(int index)
        throws java.lang.IndexOutOfBoundsException
    {
        //-- check bounds for index
        if ((index < 0) || (index > _manageInfoList.size())) {
            throw new IndexOutOfBoundsException();
        }
        
        return (ManageInfo) _manageInfoList.elementAt(index);
    } //-- ManageInfo getManageInfo(int) 

    /**
    **/
    public ManageInfo[] getManageInfo()
    {
        int size = _manageInfoList.size();
        ManageInfo[] mArray = new ManageInfo[size];
        for (int index = 0; index < size; index++) {
            mArray[index] = (ManageInfo) _manageInfoList.elementAt(index);
        }
        return mArray;
    } //-- ManageInfo[] getManageInfo() 

    /**
    **/
    public int getManageInfoCount()
    {
        return _manageInfoList.size();
    } //-- int getManageInfoCount() 

    /**
    **/
    public void removeAllManageInfo()
    {
        _manageInfoList.removeAllElements();
    } //-- void removeAllManageInfo() 

    /**
     * 
     * 
     * @param index
    **/
    public ManageInfo removeManageInfo(int index)
    {
        java.lang.Object obj = _manageInfoList.elementAt(index);
        _manageInfoList.removeElementAt(index);
        return (ManageInfo) obj;
    } //-- ManageInfo removeManageInfo(int) 

    /**
     * 
     * 
     * @param index
     * @param vManageInfo
    **/
    public void setManageInfo(int index, ManageInfo vManageInfo)
        throws java.lang.IndexOutOfBoundsException
    {
        //-- check bounds for index
        if ((index < 0) || (index > _manageInfoList.size())) {
            throw new IndexOutOfBoundsException();
        }
        _manageInfoList.setElementAt(vManageInfo, index);
    } //-- void setManageInfo(int, ManageInfo) 

    /**
     * 
     * 
     * @param manageInfoArray
    **/
    public void setManageInfo(ManageInfo[] manageInfoArray)
    {
        //-- copy array
        _manageInfoList.removeAllElements();
        for (int i = 0; i < manageInfoArray.length; i++) {
            _manageInfoList.addElement(manageInfoArray[i]);
        }
    } //-- void setManageInfo(ManageInfo) 

}
