class float_leg_payoff(object):
  def __call__(self, t, controller):
    event = controller.get_event() 
    flow = event.flow()
    id = event.reset_id()
    obs = flow.observables()[id]
    model = controller.get_model()
    env = controller.get_environment()
    adjuvant_table = controller.get_adjuvant_table()
    # lookup 'spread' in adjuvant table at flow pay date
    spread = adjuvant_table("spread"+str(id), flow.pay_date())
    requestor = model.requestor()
    state = model.state().fill(t, requestor, env)
    cpn = flow.notional()*flow.year_fraction()*(controller.libor(t, state) \
          +spread)*controller.pay_df(t, state)
    return cpn
