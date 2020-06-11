package de.jmaschad.storagesim.model

import de.jmaschad.storagesim.model.user.User

object LoadPrediction {
    private var load = Map.empty[StorageObject, Map[User, Double]]

    def getLoad(obj: StorageObject): Double = load.getOrElse(obj, Map.empty).values.sum

    def getUserLoads(obj: StorageObject): Map[User, Double] = load.getOrElse(obj, Map.empty)

    def setUsers(users: Set[User]) = {
        load = computeLoad(users)
    }

    private def computeLoad(users: Set[User]): Map[StorageObject, Map[User, Double]] = {
        users.foldLeft(Map.empty[StorageObject, Map[User, Double]]) {
            case (loadMap, user) =>
                val objectLoads = { user.objects map { obj => obj -> { (user.bandwidth * obj.size) / user.objects.size } } toMap }
                loadMap ++ {
                    objectLoads map {
                        case (obj: StorageObject, load: Double) =>
                            obj -> { loadMap.getOrElse(obj, Map.empty) + { user -> load } }
                    }
                }
        }

    }
}