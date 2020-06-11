PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH


pwd=$(pwd)
model="Model"
store="Store"
cat <<EOF >$pwd/app/model/$input_modelName$model.js
/*
 * Created by SenchaLazyGen
 */
Ext.define('${PWD##*/}.model.$input_modelName$model',{
	extend:'Ext.data.Model',
	config:{
		fields:[
			/*
			 * To Do: Add Fields Here!
			 */
			//{name:'Name',type:'string'},
			//{name:'tel,type:'string'}
			]
	}
});
EOF

cat <<EOF >$pwd/app/store/$input_modelName$store.js
/*
 * Created by SenchaLazyGen
 */
 Ext.define('${PWD##*/}.store.$input_modelName$store',{
	extend:'Ext.data.Store',
	config:{
		model:'${PWD##*/}.model.$input_modelName$model',
		storeId:'$input_modelName$store',
		
		/*
		 * To Do: Add Data Here!
		 */
		//data:[			
			//{Name:'name',tel:'tel'}
		//],
		/*
		 * To Do: Add proxy Here!
		 */
		//proxy: {
        //    type: 'rest',
        //    url : '/data/users.json',
        //    reader: {
        //        type: 'json',
        //        rootProperty: 'users'
        //    }
        //}
		
	}
});
EOF
echo -e "\033[33m...Done! SenchaLazyGen also generates store for you :)\033[m"