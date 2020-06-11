/**
 *
 * Process Editor
 *
 * (C) 2009, 2010 inubit AG
 * (C) 2014 the authors
 *
 */
package com.inubit.research.server.merger;

import com.inubit.research.server.merger.ProcessObjectDiff.ProcessObjectState;
import java.util.Collection;
import net.frapu.code.visualization.ProcessModel;
import net.frapu.code.visualization.ProcessObject;

/**
 *
 * @author Uwe
 */
public interface ProcessModelDiff {

    void dump();

    void compare(ProcessModel m1, ProcessModel m2);

    Collection<ProcessObject> getAddedObjects();

    Relation<String, ProcessObjectDiff> getChangedObjectDiffs();

    Collection<ProcessObject> getChangedObjects();

    Relation<String, ProcessObjectDiff> getEqualObjectDiffs();

    /**
     * @return the v1
     */
    ProcessModel getModel1();

    /**
     * @return the v2
     */
    ProcessModel getModel2();

    ProcessObject getPartnerProcessObject(String objectID, ProcessModel origin);

    ProcessObjectDiff getProcessObjectRelation(String objectID, ProcessModel origin);

    Collection<ProcessObject> getRemovedObjects();

    ProcessObjectState getStatus(String objectID);

}
