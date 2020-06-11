namespace SignalProcessing

module SampleBuffer =
  type T

  val create : accessor : SampleAccessor.T -> accessType : AccessType.T -> size : int -> T

  val size : T -> int
  val position : T -> int
  val data : T -> Sample.T array
  val offset : T -> int
  val get : T -> indexFromOffset : int -> Sample.T
  val set : T -> indexFromOffset : int -> sample : Sample.T -> unit

  val flush : T -> unit
  val moveBy : T -> increment : int -> unit
  val moveTo : T -> position : int -> unit

  val window : T -> windowFunction : WindowFunction.T -> toArray : Sample.T array -> unit
  val add : T -> factor : float32 -> fromArray : Sample.T array -> unit
  val add' : T -> factor : float32 -> windowFunction : WindowFunction.T -> fromArray : Sample.T array -> unit
  val norm : T -> size : int -> float32

  val copyTo : T -> dst : T -> size : int -> unit
  val copyToArray : T -> dst : Sample.T array -> unit
  val copyFromArray : T -> src : Sample.T array -> unit
