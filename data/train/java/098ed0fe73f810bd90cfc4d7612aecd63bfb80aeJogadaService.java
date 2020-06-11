package service;


public class JogadaService {
	
	private JogadorService jogadorService;
	private ConfiguraService configService;
	private JogadorLogadoService jogadorLogadoService;

	public int jogada(int x, int y) 
	{
			if(configService.getJogo().Jogada(x, y))
		 {  
			 return 1; //perdeu
		 }
		 else
		 { 
			 jogadorService.setPontos(10);
			 if(configService.getJogo().isTerminar())
			 {   
				 jogadorLogadoService.salvarVencedor();
					 return 2; //venceu
			 }
		 }
		return 3;//continue
	}
	
	public void setJogadorService(JogadorService jogadorService) {
		this.jogadorService = jogadorService;
	}
	public void setConfigService(ConfiguraService configService) {
		this.configService = configService;
	}
	public JogadorService getJogadorService() {
		return jogadorService;
	}
	public ConfiguraService getConfigService() {
		return configService;
	}

	public JogadorLogadoService getJogadorLogadoService() {
		return jogadorLogadoService;
	}

	public void setJogadorLogadoService(JogadorLogadoService jogadorLogadoService) {
		this.jogadorLogadoService = jogadorLogadoService;
	}
}
