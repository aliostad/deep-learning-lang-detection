/**
 * Created by 月飞 on 14-3-14.
 */
var api=require('../api'),
    cdn=require('../lib/cdn');
function showData(req,res,next){
    res.json(req.Data);
}
module.exports=function(app){
    //api
    app.post('/api/basicSetting/update',api.apiAuth,api.basicSettings.setSettings,function(req,res,next){
        app.locals({blog:req.Data.settings});
        next();
    },showData);
    app.post('/api/basicSite/update',api.apiAuth,api.basicSettings.update,showData);
    app.post('/api/user/update',api.apiAuth,api.user.update,showData);
    app.post('/api/user/changePassword',api.apiAuth,api.user.changePassword,showData);
    app.post('/api/post/create',api.apiAuth,api.tag.getList,api.post.create,showData);
    app.post('/api/post/update',api.apiAuth,api.tag.getList,api.post.update,showData);
    app.post('/api/post/delete',api.apiAuth,api.post.destroy,showData);
    app.get('/api/post/get',api.apiAuth,api.post.get,showData);
    app.get('/api/post/getAll',api.apiAuth,api.post.getList,showData);
    app.get('/api/tag/getAll',api.apiAuth,api.tag.getAll,showData);
    //img-cdn-api
    app.get('/api/image/getAll',api.apiAuth,cdn.list,showData);
    //frontend
};