package emasher.client

import emasher.blocks.BlockTempRS
import net.minecraft.client.Minecraft
import net.minecraft.client.renderer.tileentity.TileEntitySpecialRenderer
import net.minecraft.tileentity.TileEntity
import net.minecraft.util.{IIcon, ResourceLocation}
import org.lwjgl.opengl.GL11

class TempRSRenderer extends TileEntitySpecialRenderer {

  override def renderTileEntityAt( t: TileEntity, x: Double, y: Double, z: Double, counter: Float ): Unit = {
    GL11.glDisable( GL11.GL_LIGHTING )
    val block = emasher.blocks.Blocks.tempRS.asInstanceOf[ BlockTempRS ]
    Minecraft.getMinecraft.renderEngine.bindTexture( new ResourceLocation( "textures/atlas/blocks.png" ) )

    val bounds = if( Minecraft.getMinecraft.gameSettings.ambientOcclusion > 0 ) {
      TempRSRenderer.SMOOTH_BOUNDS
    } else {
      TempRSRenderer.OLD_BOUNDS
    }

    CubeRenderer.render( x, y, z, Array.fill[ IIcon ]( 6 ) {
      block.getIcon( 0, 0 )
    }, bounds, inverted = false )

    CubeRenderer.render( x, y, z, Array.fill[ IIcon ]( 6 ) {
      block.getIcon( 0, 0 )
    }, bounds, inverted = true )

    GL11.glEnable( GL11.GL_LIGHTING )
  }
}

object TempRSRenderer {
  final val SMOOTH_MIN = 0.4
  final val SMOOTH_MAX = 0.6
  final val SMOOTH_BOUNDS = CubeRenderBounds( SMOOTH_MIN, SMOOTH_MIN, SMOOTH_MIN, SMOOTH_MAX, SMOOTH_MAX, SMOOTH_MAX )

  final val OLD_MIN = 0.0
  final val OLD_MAX = 1.0
  final val OLD_BOUNDS = CubeRenderBounds( OLD_MIN, OLD_MIN, OLD_MIN, OLD_MAX, OLD_MAX, OLD_MAX )

  val instance = new TempRSRenderer
}
