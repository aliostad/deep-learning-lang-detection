var express = require('express');
var apiRouter = express.Router();
var apiHandler = require('../handlers/apiHandler');

//done:
apiRouter.get('/list/:path?', apiHandler.handleList);

apiRouter.post('/rename/:path', apiHandler.handleRename);

apiRouter.post('/mkdir/:path', apiHandler.handleMkDir);

apiRouter.delete('/remove/:path', apiHandler.handleRemove);

apiRouter.post('/upload/:path', apiHandler.handleUploadFile);

apiRouter.get('/download/:path', apiHandler.handleDownload);

apiRouter.post('/update/:path', apiHandler.handleUpdate);

apiRouter.get('/zip/:path', apiHandler.handleZip);

module.exports = apiRouter;
