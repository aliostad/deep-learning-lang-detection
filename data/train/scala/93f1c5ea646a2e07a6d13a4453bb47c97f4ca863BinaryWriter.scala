/*
 * This file is part of M.O.R.F.
 *                      <https://github.com/HeXLaB/M.O.R.F.>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, see <http://www.gnu.org/licenses/>.
 *
 * Copyright (c) 2013-2014
 *               HeXLaB Team
 *                           All rights reserved
 */

package hexlab.morf.util

/**
 * This class ...
 *
 * @author hex1r0
 */
trait BinaryWriter[T] {
  def writeByte(v: Int): T

  def writeShort(v: Int): T

  def writeInt(v: Int): T

  def writeLong(v: Long): T

  def writeFloat(v: Float): T

  def writeDouble(v: Double): T

  def writeBytes(v: Array[Byte]): T

  def fill(v: Int, count: Int): T


  def int8(v: Int): T = writeByte(v)

  def int16(v: Int): T = writeShort(v)

  def int32(v: Int): T = writeInt(v)

  def int64(v: Long): T = writeLong(v)

  def float32(v: Float): T = writeFloat(v)

  def float64(v: Double): T = writeDouble(v)


  def writeC(v: Int): T = writeByte(v)

  def writeH(v: Int): T = writeShort(v)

  def writeD(v: Int): T = writeInt(v)

  def writeQ(v: Long): T = writeLong(v)

  def writeF(v: Float): T = writeFloat(v)

  def writeDF(v: Double): T = writeDouble(v)

  def write(v: Array[Byte]): T = writeBytes(v)

  def write(hex: String): T = writeBytes(ByteArray(hex))
}
