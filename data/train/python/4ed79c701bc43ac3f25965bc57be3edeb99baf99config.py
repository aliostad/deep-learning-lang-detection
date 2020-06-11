import re, controller, iopin, rulebase

class Config:

    def __init__(self):
        return

    def make_controller(self):
        controllers = { }
        for c in self.config_dict['controllers']:
            cont_dict = self.config_dict['controllers'][c]
            controller_ = controller.Controller()
            controller_.name = c
            controllers[c] = controller_

            controller_.in1.name = cont_dict['in1'][0]
            controller_.in1.min = cont_dict['in1'][1]
            controller_.in1.max = cont_dict['in1'][2]
            for l in cont_dict['in1'][3]:
                controller_.in1.pushling(l)
            controller_.in1.makeling()

            controller_.in2.name = cont_dict['in2'][0]
            controller_.in2.min = cont_dict['in2'][1]
            controller_.in2.max = cont_dict['in2'][2]
            for l in cont_dict['in2'][3]:
                controller_.in2.pushling(l)
            controller_.in2.makeling()

            controller_.out.name = cont_dict['out'][0]
            controller_.out.min = cont_dict['out'][1]
            controller_.out.max = cont_dict['out'][2]
            for l in cont_dict['out'][3]:
                controller_.out.pushling(l)
            controller_.out.makeling()
            
            controller_.rulebase.rulebase = cont_dict['rules']

            controller_.integral = cont_dict['integral']

        args = self.config_dict['args']
        return controllers, args

    def read(self, fname):
        lines = filter (lambda x: x!='\n' and x != '', 
                map (lambda x: re.sub(r'#.*', '', x),
                map (lambda x: x.strip(), 
                    tuple(open(fname, 'r')))))
        config = '\n'.join(lines)
        config_dict = { 'args': {}, 'controllers' : {} }
        for entry_match in re.finditer(r'(Controller|Arguments)\s*\(([^]]*)\]\s*\)', 
                config, re.DOTALL):
            etype,ebody = entry_match.groups()
            if etype == 'Controller':
                m = re.match(r'\s*([^,]*)[^[]*\[(.*)', ebody, re.DOTALL)
                cname, cbody = m.groups()
                cont_dict = dict()
                config_dict['controllers'][cname] = cont_dict
                for param_match in re.finditer(r'\s*([^(]*)\(([^)]*)\)', 
                        cbody, re.DOTALL):
                    pname, pbody = [x.strip() for x in param_match.groups() ]
                    pvals = pbody.split(',')
                    if pname in ['in1','in2','out']:
                        ioname = pvals[0].strip()
                        iomin  = float(pvals[2].strip())
                        iomax  = float(pvals[3].strip())
                        iolist = pvals[1].strip(' {}').split(' ')
                        cont_dict[pname] = [ioname, iomin, iomax, iolist]
                    elif pname == 'rulebase':
                        rules = [ re.sub(r' +', ' ', x.strip(' {}')) 
                                for x in pbody.split('\n') ]
                        rules = [ x.split(' ') for x in rules if x != '']
                        cont_dict['rules'] = rules
                    elif pname == 'integral':
                        cont_dict[pname] = False if pbody == 'false' else True
                    else: print '"',pname,'"'
            else: 
                for arg_match in re.finditer(r'[[\s]*([^(]*)\(\s*([^)]*)\)', 
                        ebody, re.DOTALL):
                    config_dict['args'][arg_match.group(1)] = arg_match.group(2)
        self.config_dict = config_dict
        return self.make_controller()

