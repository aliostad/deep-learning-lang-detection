package ccl2of4

import net.minecraft.item.ItemStack
import net.minecraft.nbt.NBTTagCompound

package object magdump {

  class ItemStackMagDumpAddOns(val itemStack: ItemStack) {
    def subTagCompound(key: String): NBTTagCompound = {
      if (null == itemStack.getTagCompound) {
        itemStack.setTagCompound(new NBTTagCompound)
      }
      itemStack.getTagCompound
    }
    def magazineSubTagCompound: NBTTagCompound = {
      subTagCompound("magazine")
    }
    def firearmSubTagCompound: NBTTagCompound = {
      subTagCompound("firearm")
    }
  }

  implicit def ItemStackMagDumpAddOns(itemStack: ItemStack) = new ItemStackMagDumpAddOns(itemStack)

}
