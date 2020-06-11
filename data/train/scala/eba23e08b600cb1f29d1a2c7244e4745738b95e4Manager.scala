package laz.netty.http.filter

trait Interceptor[R] {
    def filter(request: R): Boolean
}

class Manager[R](interceptors: List[Interceptor[R]]) {
    def allow(request: R): Boolean = {
        try {
            for (interceptor <- interceptors) {
                if (!(interceptor filter request)) return false
            }
        } catch {
            case _ => return false
        }

        // optimistic view
        true
    }
}

object manage {
    def apply[R](interceptors: Interceptor[R]*) = new Manager(interceptors toList)
}