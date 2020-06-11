package djc.lang.lib.worker

import djc.lang.TypedLanguage._
import djc.lang.TypedLanguage.types._
import djc.lang.TypedSyntaxDerived._
import util.Bag
import djc.lang.lib.worker.Task._
import djc.lang.lib.worker.Worker._
import djc.lang.base.Integer._

object LoadAwareWorker {

  val TLoadAwareWorker = TSrvRep('work -> ?(TTask), 'getLoad -> ?(?(TInteger)), 'init -> ?())
  val TLoadAwareWorkerK = TUniv('K, TSrvRep('work -> ?(TTaskK('K), ?('K)), 'getLoad -> ?(?(TInteger)), 'init -> ?()))

  val mkLoadAwareWorkerType = TUniv('K, TFun(TWorkerK('K), TLoadAwareWorkerK('K)))
  val mkLoadAwareWorker = TAbs('K, LocalService(
    'make?('workerRep -> TWorkerK('K), 'k -> ?(TLoadAwareWorkerK('K))),
    Let('laWorker, TLoadAwareWorkerK('K) ++ TSrvRep('load -> ?(TInteger), 'worker -> ?(TSrv(TWorkerK('K)))), // internally we know that there is a 'load service
      ServerImpl(
        Rule(
          'init?(),
          'this~>'load!!(0) && 'this~>'worker!!(SpawnLocalImg('workerRep))
        ),
        Rule(
          'work?('task -> TTaskK('K), 'k -> ?('K))
            && ('worker?('worker -> TSrv(TWorkerK('K)))
            && 'load?('n -> TInteger)),
          'this~>'load!!('n + 1)
            && ('this~>'worker!!('worker)
            && Let('notifyDone, ?(), 'this~>'done)(
                'worker~>'work!!('task,
                   LocalService('cont?('res -> 'K),'notifyDone!!() && 'k!!('res)))))
        ),
        Rule(
          'done?() && 'load?('n -> TInteger),
          'this~>'load!!('n - 1)
        ),
        Rule(
          'getLoad?('notifyLoad -> ?(TInteger)) && 'load?('n -> TInteger),
          'notifyLoad!!('n) && 'this~>'load!!('n)
        )
      ))(
      'k!!('laWorker cast (TLoadAwareWorkerK('K)))
    )
  ))
}

// Def('worker, TSrv(TWorkerK('K)), SpawnLocal('workerRep),
