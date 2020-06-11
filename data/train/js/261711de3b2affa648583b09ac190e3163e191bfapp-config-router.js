define(['marionette'], function (Marionette) {
	return Marionette.AppRouter.extend({
		appRoutes: {
			'ie': 'showIePage',
			'periodoacademico': 'showPeriodoAcademico',
			
			'config/docentes': 'showDocenteList',
			'config/docente/new': 'showNewDocenteForm',
			'config/nivel': 'showNivelView',
			'config/grado': 'showGradoView',
			'config/seccion': 'showSeccionView',
			'config/clases': 'showClasesView',
			'config/clases/:id': 'showClaseFormView',
			'config/fichamonitoreo': 'showFichaDeMonitoreoListConfigView',
			'config/newfichamonitoreo': 'showNewFichaDeMonitoreoConfigView',
			'config/cargasiagie': 'showCargaSiagieFormView'
		}
	});
});