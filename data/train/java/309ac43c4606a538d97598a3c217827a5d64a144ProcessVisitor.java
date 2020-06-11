/**
 * File name£º ProcessVisitor.java
 * Author£º        wangpj
 * Create Date£º 2013-12-16
 * Description:
 * 
 */

package com.sunny.process;

import com.sunny.process.ProcessAlternation;
import com.sunny.process.ProcessSequence;
import com.sunny.process.ProcessStep;

/**
 * @author wangpj
 * 
 */
public interface ProcessVisitor {

	/**
	 * Visit a process alternation.
	 * 
	 * @param a
	 *            the process alternation to visit
	 */
	void visit(ProcessAlternation a);

	/**
	 * Visit a process sequence.
	 * 
	 * @param s
	 *            the process sequence to visit
	 */
	void visit(ProcessSequence s);

	/**
	 * Visit a process step.
	 * 
	 * @param s
	 *            the process step to visit
	 */
	void visit(ProcessStep s);

}
