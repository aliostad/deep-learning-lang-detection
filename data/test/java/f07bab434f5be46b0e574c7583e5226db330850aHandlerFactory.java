package dip.cbuu.util;

import javax.swing.JFrame;

import dip.cbuu.common.Constant;
import dip.cbuu.common.IHandler;
import dip.cbuu.common.MyFrame;
import dip.cbuu.handler.AddGaussianNoiseHandler;
import dip.cbuu.handler.AddImpluseHandler;
import dip.cbuu.handler.ArithmaticMeanHandler;
import dip.cbuu.handler.BetterDehazeHandler;
import dip.cbuu.handler.ContraHarmonicMeanHandler;
import dip.cbuu.handler.DarkChannelHandler;
import dip.cbuu.handler.DehazeHandler;
import dip.cbuu.handler.EqualizeRGBHandler;
import dip.cbuu.handler.GeometricMeanHandler;
import dip.cbuu.handler.HarmonicMeanHandler;
import dip.cbuu.handler.MaxHandler;
import dip.cbuu.handler.MedianHandler;
import dip.cbuu.handler.MinHandler;
import dip.cbuu.handler.OpenHandler;
import dip.cbuu.handler.RGBEqualizeHandler;
import dip.cbuu.handler.SaveHandler;
import dip.cbuu.processes.AddImpluseNoiseProcess;

public class HandlerFactory {
	public static IHandler createHandlerById(Constant id, MyFrame frame) {
		IHandler handler = null;
		switch (id) {
		case ARITHMATIC_MEAN:
			handler = new ArithmaticMeanHandler(frame);
			break;
		case OPEN:
			handler = new OpenHandler(frame);
			break;
		case SAVE:
			handler = new SaveHandler(frame);
			break;
		case HARMONIC_MEAN:
			handler = new HarmonicMeanHandler(frame);
			break;
		case CONTRAHARMONIC_MEAN:
			handler = new ContraHarmonicMeanHandler(frame);
			break;
		case DFT:
			break;
		case IDFT:
			break;
		case SPECTRUM:
			break;
		case FFT:
			break;
		case IFFT:
			break;
		case ADD_GAUSSIAN_NOISE:
			handler = new AddGaussianNoiseHandler(frame);
			break;
		case ADD_IMPLUSE_NOISE:
			handler = new AddImpluseHandler(frame);
			break;
		case GEOMETRIC_MEAN:
			handler = new GeometricMeanHandler(frame);
			break;
		case MIN_MEAN:
			handler = new MinHandler(frame);
			break;
		case MAX_MEAN:
			handler = new MaxHandler(frame);
			break;
		case MEDIAN_MEAN:
			handler = new MedianHandler(frame);
			break;
		case EQUALIZE_RGB:
			handler = new EqualizeRGBHandler(frame);
			break;
		case RGB_EQUALIZE:
			handler = new RGBEqualizeHandler(frame);
			break;
		case GET_DARKCHANNEL:
			handler = new DarkChannelHandler(frame);
			break;
		case DEHAZE:
			handler = new DehazeHandler(frame);
			break;
		case BETTER_DEHAZE:
			handler = new BetterDehazeHandler(frame);
			break;
		default:
			break;
		}
		return handler;
	}
}
