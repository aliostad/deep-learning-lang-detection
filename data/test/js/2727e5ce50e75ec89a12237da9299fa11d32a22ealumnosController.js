module.exports = (function() {
    var AlumnosController = function(express, alumnosApi) {
        this.express = express.module;
        this.alumnosApi = alumnosApi;
        this.router = this.express.Router();
        
        var router = this.router;
        
        router.get('/', alumnosApi.getAll.bind(alumnosApi));
        
        router.post('/', alumnosApi.save.bind(alumnosApi));
        
        router.get('/:id', alumnosApi.getOne.bind(alumnosApi));
        
        router.put('/', alumnosApi.update.bind(alumnosApi));
        
        router.delete('/:id', alumnosApi.delete.bind(alumnosApi));

    }
    
    return AlumnosController;
})();