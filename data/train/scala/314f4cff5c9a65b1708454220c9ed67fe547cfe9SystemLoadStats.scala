/*
 * Copyright (C) 2014 - 2017  Contributors as noted in the AUTHORS.md file
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package models

/**
  * A simple helper class for system load stats.
  *
  * @param load       The system load.
  * @param maxLoad    The maximum system load.
  * @param processors The number of processors.
  */
case class SystemLoadStats(load: Double, maxLoad: Double, processors: Int) {

  lazy val loadPercentage: Double = load * 100 / maxLoad

}
