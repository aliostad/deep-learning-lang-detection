#!/usr/bin/env node
var etcdjs = require('etcdjs')
var config = require('../config')()
var Dispatch = require('../deployment/dispatch')
var logger = require('../tools/logger')

module.exports = function(args){
  args = args || {}
  var etcd = etcdjs(config.network.etcd)
  var dispatch = Dispatch(config, etcd)

  var mod = {
    boot:function(){
      var cmd = args._[3]

      dispatch.run(function(err){
        if(err){
          logger.error(err)
          process.exit()
        }
      })
      
    }
  }

  return mod
  
}
