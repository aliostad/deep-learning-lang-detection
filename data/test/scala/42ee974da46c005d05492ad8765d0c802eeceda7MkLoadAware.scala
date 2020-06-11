package djc.lang.lib.combinators.loadbalance

import djc.lang.TypedLanguage._
import djc.lang.TypedLanguage.types._
import djc.lang.TypedSyntaxDerived.{TThunk => _, _}
import djc.lang.base.Integer._
import djc.lang.lib.combinators._

object MkLoadAware extends Combinator {
  def apply(t1: Type, t2: Type) = TApp(impl, t1, t2)

  val TInternal = TUniv('A, TUniv('W, TWorker('A),
    TSrv(TSrvRep('init -> ?(), 'work -> TFun(TThunk('A) -> 'A), 'instance -> ?(TSrv('W)),
            'getLoad -> ?(?(TInteger)), 'done -> ?(), 'load -> ?(TInteger)))))

  val tpe = TUniv('A, TUniv('W, TWorker('A), TSrvRep('make -> ?('W, ?(TLaWorker('A))))))
  val impl = TAbs('A, 'W << TWorker('A)) {
    ServerImpl {
      Rule('make?('worker -> 'W, 'k -> ?(TLaWorker('A)))) {
        Let('laWorker, TLaWorker('A),
          ServerImpl (
            Rule('init?()) {
              Let(TInternal('A, 'W))('w, TSrv('W), SpawnLocalImg('worker)) {
                'w~>'init!!() && 'this~>'instance!!'w && 'this~>'load!!0
              }
            },
            Rule('work?('thunk -> TThunk('A), 'k -> ?('A)),
                 'instance?('w -> TSrv('W)),
                 'load?('n -> TInteger)) {
                  ('this~>'load!!('n + 1) && 'this~>'instance!!'w
                   && Letk(TInternal('A,'W))('res, 'A, 'w~>'work!!'thunk) { 'k!!'res && 'this~>'done!!()  })
            },
            Rule('done?(), 'load?('n -> TInteger)) {
              'this~>'load!!('n - 1)
            },
            Rule('getLoad?('r -> ?(TInteger)), 'load?('n -> TInteger)) {
              'r!!'n && 'this~>'load!!'n
            })) {
          'k!!'laWorker
        }
      }
    }
  }
}
