package nl.progaia.esbprocessdraw.draw.esb;

import nl.progaia.esb.Process;
import nl.progaia.esbprocessdraw.draw.Drawable;
import nl.progaia.esbprocessdraw.draw.TitledBorder;

public class ESBProcess extends ESBItinerary {
	private final Process process;
	
	public ESBProcess(Process process) {
		super(process.getItinerary());
	
		TitledBorder border = new TitledBorder(process.getName(), 5, 5, 0, 5);
		border.setRounded(true);
		setBorder(border);
		
//		System.out.println("Found process: " + process.getName());
		
		this.process = process;
	}
	 
	public String getName() {
		return process.getName();
	}
	
	public Process getProcess() {
		return process;
	}

	public static Drawable getProcess(String name) {
//		Process p = Main.getArtifactStore().getProcess(name);
//		if(p == null) {
			return new ESBProcessStep(name);
//		} else {
//			return new ESBProcess(p);
//		}
	}
	
}
