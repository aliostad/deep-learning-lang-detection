import os.path

from settings import BASEDIR
from settings import WHITE_SPACE

def generate_controller(model_name, model_components):
    model_name = model_name.lower()
    db_model_name = model_name.title()
    controller_path = os.path.join(BASEDIR, 'controllers/' + model_name + '.py')
    
    controller_file = open(controller_path,'w')
    controller_file.write("from flask import Blueprint\n")
    controller_file.write("from flask import render_template\n")
    controller_file.write("from flask import json\n")
    controller_file.write("from flask import session\n")
    controller_file.write("from flask import url_for\n")
    controller_file.write("from flask import redirect\n")
    controller_file.write("from flask import request\n")
    controller_file.write("from flask import abort\n")
    controller_file.write("from flask import Response\n")
    controller_file.write("from helpers import new_parser\n")
    controller_file.write("from helpers import edit_parser\n\n")

    # import related models
    controller_file.write("from models import " + db_model_name +"\n\n")

    # create blueprint
    controller_file.write(model_name+"_view = Blueprint('"+model_name+"_view', __name__)\n\n")

    controller_file.write("########### " + model_name + " REST controller ###########\n\n")
    controller_file.write("@"+model_name+"_view.route('/" + model_name + "/',methods=['GET','POST'],defaults={'id':None})\n")
    controller_file.write("@"+model_name+"_view.route('/" + model_name + "/<id>',methods=['GET','PUT','DELETE'])\n")
    controller_file.write("def " + model_name + "_controller(id):\n")
    for component in model_components:
        controller_file.write(WHITE_SPACE + component['field_name'].lower() + " = request.values.get('" + component['field_name'].lower() + "')\n")
    controller_file.write("\n"+ WHITE_SPACE +"if id:\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + model_name+" = "+model_name.title()+".query("+model_name.title()+".id==id).get()\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + "if "+model_name+":\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + "if request.method == 'GET':\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + "if request.values.get('json'):\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + "return json.dumps(dict("+model_name+"="+model_name+".json))\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + WHITE_SPACE +"return render_template('" + model_name + "_view.html'," + model_name + " = " + model_name + ", title = \"" + model_name.title() + " List\")\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + "elif request.method == 'PUT':\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + model_name + " = edit_parser(" + model_name + ",request)\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + model_name + ".put()\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + "return 'Value Updated', 204\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + "elif request.method == 'DELETE':\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + model_name + ".delete()\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + "return 'Item deleted', 204\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + "else:\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + WHITE_SPACE +"return 'Method Not Allowed'\n")
    controller_file.write(WHITE_SPACE + "else:\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + "if request.method == 'GET':\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + model_name + "_list = "+model_name.title()+".query().fetch(1000)\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + "entries=None\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + "if " + model_name + "_list:\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + "entries = [" + model_name + ".dto() for " + model_name + " in " + model_name + "_list]\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + "if request.values.get('json'):\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + "return json.dumps(dict("+model_name+"=entries))\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + "return render_template('" + model_name + ".html'," + model_name + "_entries = entries, title = \"" + model_name.title() + " List\")\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + "elif request.method == 'POST':\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + model_name + " = "+model_name.title()+"()\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + model_name + " = new_parser("+model_name+",request)\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + model_name + ".put()\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + "url = '/"+model_name+"/'\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + "if request.values.get('json'):\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + "url = '/"+model_name+"/json=true'\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + "return redirect(url)\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + "else:\n")
    controller_file.write(WHITE_SPACE + WHITE_SPACE + WHITE_SPACE + "return abort(405)\n\n")
    controller_file.close()

    main_path = os.path.join(BASEDIR, 'main.py')
    read_main_file = open(main_path, 'r')
    original_lines = read_main_file.readlines()
    ## import the blueprint file
    original_lines[7] = original_lines[7].strip()
    original_lines[7] = original_lines[7] + ', ' + model_name + '_view\n'
    
    
    main_file = open(main_path, 'w')

    for lines in original_lines:
        main_file.write(lines)
    main_file.close()

    main_file = open(main_path,'a')
    main_file.write("\napp.register_blueprint(" + model_name + "_view)")
    main_file.close()

    init_path = os.path.join(BASEDIR, 'controllers/__init__.py')
    init_file = open(init_path, 'a')
    init_file.write("\nfrom "+ model_name + " import "+model_name+ "_view")
    init_file.close()

    print "REST controller generated"

def add_controller(controller_name):
    controller_name = controller_name.lower()
    controller_name = controller_name.replace(' ', '_')
    controller_name = controller_name.replace('\'', '_')
    controller_name = controller_name.replace('.', '_')
    controller_name = controller_name.replace(',', '_')
    controller_path = os.path.join(BASEDIR, "app/controllers/" + controller_name + ".py")
    view_path = os.path.join(BASEDIR, "app/templates/" + controller_name + ".html")

    controller_file = open(controller_path, 'w')
    controller_file.write("from flask import Blueprint\n")
    controller_file.write("from flask import render_template\n")
    controller_file.write("from flask import json\n")
    controller_file.write("from flask import session\n")
    controller_file.write("from flask import url_for\n")
    controller_file.write("from flask import redirect\n")
    controller_file.write("from flask import request\n")
    controller_file.write("from flask import abort\n")
    controller_file.write("from flask import Response\n\n")

    controller_file.write(controller_name + "_view = Blueprint('" + controller_name + "_view', __name__)\n\n")

    controller_file.write("@" + controller_name + "_view.route('/" + controller_name + "/') #Link\n")
    controller_file.write("def " + controller_name + "_control():\n")
    controller_file.write(WHITE_SPACE + "# add your controller here\n")
    controller_file.write(WHITE_SPACE + "return render_template('" + controller_name + ".html')\n")
    controller_file.close()

    main_path = os.path.join(BASEDIR, 'main.py')
    read_main_file = open(main_path, 'r')
    original_lines = read_main_file.readlines()

    ## import the blueprint file
    original_lines[2] = original_lines[2].strip()
    original_lines[2] = original_lines[2] + ', ' + controller_name + '_view\n'

    main_path = os.path.join(BASEDIR, 'main.py')
    main_file = open(main_path, 'w')

    for lines in original_lines:
        main_file.write(lines)
    main_file.close()

    main_file = open(main_path,'a')
    main_file.write("\napp.register_blueprint(" + controller_name + "_view)")
    main_file.close()

    init_path = os.path.join(BASEDIR, 'controllers/__init__.py')
    init_file = open(init_path, 'a')
    init_file.write("\nfrom "+ controller_name + " import " + controller_name + "_view")
    init_file.close()

    print '\nController generated\n'

    view_file = open(view_path, 'a')
    view_file.write("{% extends \"base.html\" %}\n")
    view_file.write("{% block content %}\n")
    view_file.write('\t\t<h1>The ' + controller_name.lower() + ' view.</h1>\n')
    view_file.write('\t\t<p>You can change this view in ' + view_path + '</p>\n')
    view_file.write("{% endblock %}")

    print '\nview file generated and available at ' + view_path + '\n'


# end of file