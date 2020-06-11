package palilemmatizingserver.handler;


import tagger.CombinedTagger;
import de.general.log.ILogInterface;


public class HandlerStrategyManager
{

	////////////////////////////////////////////////////////////////
	// Constants
	////////////////////////////////////////////////////////////////

	////////////////////////////////////////////////////////////////
	// Variables
	////////////////////////////////////////////////////////////////

	private GeneratorHandler generatorHandler;
	private AnalyzerHandler analyzerHandler;
	private LemmatizerHandler lemmatizerHandler;
	private StemmerHandler stemmerHandler;
	private SandhiMergeHandler sandhiMergeHandler;
	private SandhiSplitHandler sandhiSplitHandler;
	private NullHandler nullHandler;
	private AnalyzerNoDictionaryHandler analyzerNoDictionaryHandler;
	private SandhiSolverHandler sandhiSolverHandler;
	private CombinedTaggerHandler combinedTaggerHandler;
	
	////////////////////////////////////////////////////////////////
	// Constructors
	////////////////////////////////////////////////////////////////

	public HandlerStrategyManager()
	{
		generatorHandler = new GeneratorHandler();
		analyzerHandler = new AnalyzerHandler();
		lemmatizerHandler = new LemmatizerHandler();
		stemmerHandler = new StemmerHandler();
		sandhiMergeHandler = new SandhiMergeHandler();
		sandhiSplitHandler = new SandhiSplitHandler();
		nullHandler = new NullHandler();
		analyzerNoDictionaryHandler = new AnalyzerNoDictionaryHandler();
		sandhiSolverHandler = new SandhiSolverHandler();
		combinedTaggerHandler = new CombinedTaggerHandler();
	}

	////////////////////////////////////////////////////////////////
	// Methods
	////////////////////////////////////////////////////////////////

	public AbstractHandler getHandler(String path, ILogInterface logger)
	{
		switch(path) {
			case "/api/json/morphgen":
				return generatorHandler;
			case "/api/json/morphana":
				return analyzerHandler;
			case "/api/json/lemma":
				return lemmatizerHandler;
			case "/api/json/stem":
				return stemmerHandler;
			case "/api/json/smerge":
				return sandhiMergeHandler;
			case "/api/json/ssplit":
				return sandhiSplitHandler;
			case "/api/json/morphanand":
				return analyzerNoDictionaryHandler;
			case "/api/json/sandhisolver":
				return sandhiSolverHandler;
			case "/api/json/tagger":
				return combinedTaggerHandler;
			default:
				logger.warn("No suitable handler found for path " + path);
				return nullHandler;
		}
	}
}
