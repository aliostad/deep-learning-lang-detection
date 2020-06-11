namespace CATALINA.UDF.Library
open System.Numerics

/// Fourier Analysis Methods
module FFT =
  open MathNet.Numerics.IntegralTransforms

  /// forward Fourier transform
  let forward (samples:Complex[]) =
    let fft_x = samples |> Array.copy
    Transform.FourierForward(fft_x, FourierOptions.Matlab)
    fft_x

  /// inverse Fourier transform
  let inverse (samples:Complex[]) =
    let ifft_x = samples |> Array.copy
    Transform.FourierInverse(ifft_x, FourierOptions.Matlab)
    ifft_x

  /// Heckman-Meyers Probability Generating Function
  let pgf expectedCount contagion samples =
    let pgf (x:Complex) =
      match contagion with
      |0. -> exp (Complex(expectedCount,0.) * (x - Complex.One))
      |_  -> (Complex.One - Complex(expectedCount*contagion, 0.) * 
              (x-Complex.One)) ** (-1./contagion)
    samples |> Array.map pgf

  // FFT of the convolution of two marginals given the FFT 
  // of the two marginals as inputs.  Method assumes
  // independence between the two marginals
  let convolution (a:Complex[]) (b:Complex[]) =
    Array.zip a b |> Array.map (fun (a,b) -> a*b)
  // the FFT of a discrete probability array with prob(x=0) = 1
  let zeroTransform totalSteps =
    Array.create totalSteps Complex.One