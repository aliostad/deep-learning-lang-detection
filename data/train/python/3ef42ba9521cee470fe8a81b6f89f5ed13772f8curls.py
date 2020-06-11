from django.conf.urls import patterns, include, url

urlpatterns = patterns('',
    url(r'^ecg_app/$', 'app.controller.ecg_controller.index'),
    url(r'^ecg_app/1$', 'app.controller.ecg_controller.opcao1'),
    url(r'^ecg_app/2$', 'app.controller.ecg_controller.opcao2'),
    url(r'^ecg_app/3$', 'app.controller.ecg_controller.opcao3'),
    url(r'^ecg_app/4$', 'app.controller.ecg_controller.opcao4'),
    url(r'^ecg_app/5$', 'app.controller.ecg_controller.opcao5'),
    url(r'^ecg_app/6$', 'app.controller.ecg_controller.opcao6'),
    url(r'^ecg_app/7$', 'app.controller.ecg_controller.opcao7'),
    url(r'^ecg_app/8$', 'app.controller.ecg_controller.opcao8'),	
)
