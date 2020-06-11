package bioner.application.bc2gm;

import bioner.application.api.BioNERProcessFactory;
import bioner.application.bc2gn.ProcessImpBC2GNFilterAfterGetCandidate;
import bioner.application.bc2gn.ProcessImpBC2GNGMFilter;
import bioner.global.GlobalConfig;
import bioner.normalization.ProcessImpGetCandidateID;
import bioner.normalization.candidate.CandidateFinder;
import bioner.process.BioNERProcess;
import bioner.process.crf.ProcessImpCRFPP;
import bioner.process.crf.ProcessImpGRMMLineCRF;
import bioner.process.common.ProcessImpEntityFilter;
import bioner.process.common.ProcessImpGetEntityFromLabel;
import bioner.process.knowledgebase.ProcessImpDiseaseNER;
import bioner.process.knowledgebase.ProcessImpDrugNER;
import bioner.process.organismner.ProcessImpOrgnismNER;
import bioner.process.postprocess.ProcessImpAddEntitiesInBrackets;
import bioner.process.postprocess.ProcessImpAddSimilarEntities;
import bioner.process.postprocess.ProcessImpPostProcessEntityFilter;
import bioner.process.postprocess.ProcessImpRightBoundAdjust;
import bioner.process.preprocess.ProcessImpPreprocess;
import bioner.process.proteinner.ProcessImpProteinABNER;
import bioner.process.proteinner.ProcessImpProteinBANNER;
import bioner.process.proteinner.ProcessImpProteinIndexNER;
import bioner.process.proteinner.ProcessImpProteinNER;
import bioner.process.common.ProcessImpSetLable;

public class BC2GMProcessFactory implements BioNERProcessFactory{

	@Override
	public BioNERProcess[] buildProcessPipeline() {
		// TODO Auto-generated method stub
		CandidateFinder m_finder = new CandidateFinder();
		BioNERProcess[] pipeline = new BioNERProcess[1];
		pipeline[0] = new ProcessImpCRFPP(GlobalConfig.CRF_INEXACT_MODEL_FILEPATH, GlobalConfig.ENTITY_LABEL_CRF);
		//pipeline[0] = new ProcessImpProteinBANNER();
		//pipeline[0] = new ProcessImpGRMMLineCRF();
		//pipeline[0] = new ProcessImpProteinIndexNER();
		//pipeline[0] = new ProcessImpProteinABNER();
		//pipeline[0] = new ProcessImpGoldStandardNER("../../BC2GN/bc2GNtest.genelist");
		//pipeline[1] = new ProcessImpBC2GNGMFilter();
		//pipeline[2] = new ProcessImpGetCandidateID(m_finder);
		//pipeline[3] = new ProcessImpBC2GNFilterAfterGetCandidate();
		return pipeline;
	}
}
