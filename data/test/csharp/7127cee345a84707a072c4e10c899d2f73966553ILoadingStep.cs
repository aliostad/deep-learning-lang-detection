using System;

public interface ILoadingStep
{
	DefineBase.LOAD_STEP Load_Step	{ get; set; }
	void Update();
	void LoadStep();
	void LoadStep1();
	void LoadStep2();
	void LoadStep3();
	void LoadStep4();
	void LoadStep5();
	void LoadStep1_End();
	void LoadStep2_End();
	void LoadStep3_End();
	void LoadStep4_End();
	void LoadStep5_End();
	void LoadStepLoading_End();
	void EndLoadStep();
	
/*
#region ILoadingStep
	private LOAD_STEP	m_vLoadStep;
	public void Update()
	{
		if(Load_Step != LOAD_STEP._NULL)
		{
			LoadStep();
		}
	}
	public DefineBase.LOAD_STEP Load_Step
	{
		get { return m_vLoadStep; }
		set { m_vLoadStep = value; }
	}
	public void LoadStep()
	{
		switch(Load_Step)
		{
		case LOAD_STEP._STEP1:		LoadStep1();		break;
		case LOAD_STEP._STEP1_END:	LoadStep1_End();	break;
		case LOAD_STEP._STEP2:		LoadStep2();		break;
		case LOAD_STEP._STEP2_END:	LoadStep2_End();	break;
		case LOAD_STEP._STEP3:		LoadStep3();		break;
		case LOAD_STEP._STEP3_END:	LoadStep3_End();	break;
		case LOAD_STEP._STEP4:		LoadStep4();		break;
		case LOAD_STEP._STEP4_END:	LoadStep4_End();	break;
		case LOAD_STEP._STEP5:		LoadStep5();		break;
		case LOAD_STEP._STEP5_END:	LoadStep5_End();	break;
		}
	}
	public virtual void LoadStep1()		{}
	public virtual void LoadStep2()		{}
	public virtual void LoadStep3()		{}
	public virtual void LoadStep4()		{}
	public virtual void LoadStep5()		{}
	public virtual void LoadStep1_End()	{}
	public virtual void LoadStep2_End()	{}
	public virtual void LoadStep3_End()	{}
	public virtual void LoadStep4_End()	{}
	public virtual void LoadStep5_End()	{}
	public void LoadStepLoading_End()
	{
		switch(Load_Step)
		{
		case LOAD_STEP._STEP1_LOADING:	Load_Step	= LOAD_STEP._STEP1_END;		break;
		case LOAD_STEP._STEP2_LOADING:	Load_Step	= LOAD_STEP._STEP2_END;		break;
		case LOAD_STEP._STEP3_LOADING:	Load_Step	= LOAD_STEP._STEP3_END;		break;
		case LOAD_STEP._STEP4_LOADING:	Load_Step	= LOAD_STEP._STEP4_END;		break;
		case LOAD_STEP._STEP5_LOADING:	Load_Step	= LOAD_STEP._STEP5_END;		break;
		}
	}
	public void EndLoadStep()
	{
		Load_Step	= LOAD_STEP._NULL;
	}
#endregion
*/
}