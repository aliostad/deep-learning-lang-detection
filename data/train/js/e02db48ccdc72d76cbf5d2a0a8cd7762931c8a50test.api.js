/**
 * Created by QingWang on 2014/8/8.
 */

var supertest = require('supertest'),
    api = supertest('http://localhost:1337');
var apid ="";


describe('#Api#AddApi', function () {

    it('api#/api/manage/SaveApi#AddApi', function (done) {
        api.post('/api/manage/SaveApi')
            .send({ router : "post /api/manage/SaveApi",value:"100",notes:"AddApi" })
            .expect(200)
            .end(function (err, res) {
                if (err) {
                    done(err);
                } else {
                    done();
                }
            });
    });
});

describe('#Api#GetApiByCondition', function () {

    it('api#/api/manage/GetApiByCondition#GetApiByCondition', function (done) {
        api.post('/api/manage/GetApiByCondition')
            .send({router:"post /api/manage/SaveApi"})
            .expect(200)
            .end(function (err, res) {
                if (err) {
                    done(err);
                } else {
                    var tx =res.text;
                    var json = JSON.parse(tx);
                    apid = json.Data[0].id;
                    done();
                }
            });
    });
});

describe('#Api#GetApiById', function () {

    it('api#/api/manage/GetApiById#GetApiById', function (done) {
        api.post('/api/manage/GetApiById')
            .send({id:apid})
            .expect(200)
            .end(function (err, res) {
                if (err) {
                    done(err);
                } else {

                    done();
                }
            });
    });
});

describe('#Api#UpdateApi', function () {

    it('api#/api/manage/SaveApi#UpdateApi', function (done) {
        api.put('/api/manage/SaveApi')
            .send({id:apid, router : "put /api/manage/SaveApi",value:"100",notes:"UpdateApi" })
            .expect(200)
            .end(function (err, res) {
                if (err) {
                    done(err);
                } else {
                    done();
                }
            });
    });
});


 describe('#Api#DeleteApiById', function () {

 it('api#/api/manage/SaveApi#DeleteApiById', function (done) {
 api.delete('/api/manage/SaveApi')
 .send({id:apid})
 .expect(200)
 .end(function (err, res) {
 if (err) {
 done(err);
 } else {
 done();
 }
 });
 });
 });
