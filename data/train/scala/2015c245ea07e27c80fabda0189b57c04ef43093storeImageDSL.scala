package utils.imagestorage.algebra

import java.io.File

/** Image storage DSL
  * @usecase Manage images
  * @author nicko
  */
object storeImageDSL {

  /** Image management DSL
    * @author nicko
    */
  sealed trait ImageManagementDSL[+A]

  /** Create image 
    * @param key String
    * @author nicko
    */
  case class CreateImage[T](key: String) extends ImageManagementDSL[Unit]

  /** Read image
    * @param imageName String
    * @author nicko
    */
  case class ReadFile[T](imageName: File) extends ImageManagementDSL[File]

  /** Update image
    * @param image String
    * @author nicko
    */
  case class UpdateFile[T](image: File) extends ImageManagementDSL[Unit]

  /** Delete image
    * @param imageName String
    * @author nicko
    */
  case class DeleteFile[T](imageName: File) extends ImageManagementDSL[Unit]

}
