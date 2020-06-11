import django.dispatch

assassin_life_signal = django.dispatch.Signal(providing_args=['changed', 'status'])
assassin_role_signal = django.dispatch.Signal(providing_args=['changed', 'role'])
assassin_deadline_signal = django.dispatch.Signal(providing_args=['deadline'])

squad_life_signal = django.dispatch.Signal(providing_args=['changed', 'status'])
squad_member_signal = django.dispatch.Signal(providing_args=['change', 'member'])

game_signal = django.dispatch.Signal(providing_args=['changed', 'status'])
contract_status_signal = django.dispatch.Signal(providing_args=['changed', 'status'])

kill_signal = django.dispatch.Signal()
