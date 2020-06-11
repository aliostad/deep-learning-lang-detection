package analyzer.syntax.descending;

import analyzer.syntax.blank.SyntaxAnalyzer;
import analyzer.util.handler.ErrorHandler;
import analyzer.util.handler.OutputHandler;

public class DescendingSyntaxAnalyzer extends SyntaxAnalyzer {

	private ProcedureHandler pHandler;

	public DescendingSyntaxAnalyzer(OutputHandler outputHandler) {
		super(outputHandler);
	}

	@Override
	public void analyzeSyntax() {
		if (!outputHandler.getCodeWasTranslated()) {
			ErrorHandler.error(99, 0);
			return;
		}
		pHandler = new ProcedureHandler(outputHandler);

		if (pHandler.pProgram() != 0) {
			for (int i = 0; i < pHandler.getErrorCode().size(); i++)
				ErrorHandler.error(pHandler.getErrorCode().get(i), pHandler
						.getErrorLine().get(i));
		} else {
			System.out.println("Code was analyzed.");
			outputHandler.setCodeWasAnalyzed(true);
		}

	}

}
