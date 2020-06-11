package fc.device

/*
 Device is a simple convenience which bundles a device address and controller together. It's unlikely the controller
 associated with a device (address) will change over the course of an application so this makes it easier to manage.
 */
trait Device { self =>
  val address: Address
  implicit val controller: Controller { type Bus = address.Bus; type Register = self.Register }
  type Register

  def read(rx: Rx { type Register = self.Register }): DeviceResult[rx.T] = rx.read(address)(controller)
  def write(tx: Tx { type Register = self.Register })(value: tx.T): DeviceResult[Unit] = tx.write(address, value)(controller)
}
