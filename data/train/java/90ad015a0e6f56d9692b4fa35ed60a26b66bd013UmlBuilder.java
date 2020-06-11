package fr.lip6.move.processGenerator.uml2;

import org.eclipse.uml2.uml.Action;
import org.eclipse.uml2.uml.ActivityFinalNode;
import org.eclipse.uml2.uml.DecisionNode;
import org.eclipse.uml2.uml.FlowFinalNode;
import org.eclipse.uml2.uml.ForkNode;
import org.eclipse.uml2.uml.InitialNode;
import org.eclipse.uml2.uml.JoinNode;
import org.eclipse.uml2.uml.MergeNode;

/**
 * Cette classe permet de construire rapidement diverses {@link UmlProcess}.
 * 
 * @author Vincent
 * 
 */
public class UmlBuilder {
	
	public static UmlBuilder instance = new UmlBuilder();
	
	private UmlBuilder() {}
	
	/**
	 * Construit un process simple : InitialNode -> FlowFinalNode.
	 * 
	 * @return
	 */
	public UmlProcess initialFinal() {
		UmlProcess process = new UmlProcess();
		InitialNode init = process.buildInitialNode();
		FlowFinalNode finalNode = process.buildFlowFinalNode();
		process.buildControlFlow(init, finalNode);
		return process;
	}
	
	/**
	 * Construit un process : initial -> A -> B -> final.
	 * 
	 * @return
	 */
	public UmlProcess initialABFinal() {
		UmlProcess process = new UmlProcess();
		
		// les noeuds
		InitialNode init = process.buildInitialNode();
		Action a = process.buildAction();
		Action b = process.buildAction();
		FlowFinalNode finalNode = process.buildFlowFinalNode();
		
		// les arcs
		process.buildControlFlow(init, a);
		process.buildControlFlow(a, b);
		process.buildControlFlow(b, finalNode);
		
		return process;
	}
	
	/**
	 * Construit un process : initial -> A -> B -> C -> final.
	 * 
	 * @return
	 */
	public UmlProcess initialABCFinal() {
		UmlProcess process = new UmlProcess();
		
		// les noeuds
		InitialNode init = process.buildInitialNode();
		Action a = process.buildAction();
		Action b = process.buildAction();
		Action c = process.buildAction();
		FlowFinalNode finalNode = process.buildFlowFinalNode();
		
		// les arcs
		process.buildControlFlow(init, a);
		process.buildControlFlow(a, b);
		process.buildControlFlow(b, c);
		process.buildControlFlow(c, finalNode);
		
		return process;
	}
	
	/**
	 * Construit un process contenant un fork.
	 * 
	 * @return
	 */
	public UmlProcess buildForkExample() {
		UmlProcess process = new UmlProcess();
		
		// les noeuds
		InitialNode initial = process.buildInitialNode();
		ForkNode fork = process.buildForkNode();
		Action a = process.buildAction();
		Action b = process.buildAction();
		JoinNode join = process.buildJoinNode();
		FlowFinalNode finalNode = process.buildFlowFinalNode();
		
		// les arcs
		process.buildControlFlow(initial, fork);
		process.buildControlFlow(fork, a);
		process.buildControlFlow(fork, b);
		process.buildControlFlow(a, join);
		process.buildControlFlow(b, join);
		process.buildControlFlow(join, finalNode);
		
		return process;
	}
	
	/**
	 * Créé un process avec un exemple de décision.
	 * 
	 * @return
	 */
	public UmlProcess buildDecisionExample() {
		UmlProcess process = new UmlProcess();
		
		// les noeuds
		InitialNode initial = process.buildInitialNode();
		DecisionNode decision = process.buildDecisionNode();
		Action a = process.buildAction();
		Action b = process.buildAction();
		MergeNode merge = process.buildMergeNode();
		FlowFinalNode finalNode = process.buildFlowFinalNode();
		
		// les arcs
		process.buildControlFlow(initial, decision);
		process.buildControlFlow(decision, a);
		process.buildControlFlow(decision, b);
		process.buildControlFlow(a, merge);
		process.buildControlFlow(b, merge);
		process.buildControlFlow(merge, finalNode);
		
		return process;
	}
	
	/**
	 * Créé un process avec un exemple de boucle (1 boucle).
	 * 
	 * @return
	 */
	public UmlProcess buildLoopExample() {
		UmlProcess process = new UmlProcess();
		
		// les noeuds
		InitialNode initial = process.buildInitialNode();
		MergeNode merge = process.buildMergeNode();
		Action a = process.buildAction();
		DecisionNode decision = process.buildDecisionNode();
		FlowFinalNode finalNode = process.buildFlowFinalNode();
		
		// les arcs
		process.buildControlFlow(initial, merge);
		process.buildControlFlow(merge, a);
		process.buildControlFlow(a, decision);
		process.buildControlFlow(decision, merge);
		process.buildControlFlow(decision, finalNode);
		
		return process;
	}
	
	/**
	 * Créé un process avec un exemple de boucle (2 boucles).
	 * 
	 * @return
	 */
	public UmlProcess buildDoubleLoopExample() {
		UmlProcess process = new UmlProcess();
		
		// les noeuds
		InitialNode initial = process.buildInitialNode();
		MergeNode merge1 = process.buildMergeNode();
		Action a = process.buildAction();
		DecisionNode decision1 = process.buildDecisionNode();
		MergeNode merge2 = process.buildMergeNode();
		Action b = process.buildAction();
		DecisionNode decision2 = process.buildDecisionNode();
		FlowFinalNode finalNode = process.buildFlowFinalNode();
		
		// les arcs
		process.buildControlFlow(initial, merge1);
		
		process.buildControlFlow(merge1, a);
		process.buildControlFlow(a, decision1);
		process.buildControlFlow(decision1, merge1);
		
		process.buildControlFlow(decision1, merge2);
		process.buildControlFlow(merge2, b);
		process.buildControlFlow(b, decision2);
		process.buildControlFlow(decision2, merge2);
		
		process.buildControlFlow(decision2, finalNode);
		
		return process;
	}

	/**
	 * Créé un process avec une terminaison explicite.
	 * 
	 * @return
	 */
	public UmlProcess buildExpliciteTermination() {
		UmlProcess process = new UmlProcess();
		
		// les noeuds
		InitialNode initial = process.buildInitialNode();
		ForkNode fork = process.buildForkNode();
		Action a = process.buildAction();
		ActivityFinalNode finalExplicitNode = process.buildActivityFinalNode();
		FlowFinalNode finalNode = process.buildFlowFinalNode();
		
		// les arcs
		process.buildControlFlow(initial, fork);
		process.buildControlFlow(fork, a);
		process.buildControlFlow(a, finalExplicitNode);
		process.buildControlFlow(fork, finalNode);
		
		return process;
	}

	/**
	 * Créé un process avec une terminaison implicite.
	 * 
	 * @return
	 */
	public UmlProcess buildImplicitTermination() {
		UmlProcess process = new UmlProcess();
		
		// les noeuds
		InitialNode initial = process.buildInitialNode();
		ForkNode fork = process.buildForkNode();
		Action a = process.buildAction();
		FlowFinalNode finalImplicitNode = process.buildFlowFinalNode();
		FlowFinalNode finalNode = process.buildFlowFinalNode();
		
		// les arcs
		process.buildControlFlow(initial, fork);
		process.buildControlFlow(fork, a);
		process.buildControlFlow(a, finalImplicitNode);
		process.buildControlFlow(fork, finalNode);
		
		return process;
	}
}
