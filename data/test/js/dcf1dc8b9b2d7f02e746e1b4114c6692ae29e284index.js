import angular from 'angular';

import { clientService } from './client.service';
import { departmentService } from './department.service';
import { doctorService } from './doctor.service';
import { employeeService } from './employee.service';
import { equipmentService } from './equipment.service';
import { medicineIncomeService } from './medicine-income.service';
import { medicineOutgoService } from './medicine-outgo.service';
import { roleService } from './role.service';
import { sectionService } from './section.service';
import { serviceService } from './service.service';
import { ticketService } from './ticket.service';

export const EntityModule = angular.module('app.services.entity', [])

    .service({ clientService })
    .service({ departmentService })
    .service({ doctorService })
    .service({ employeeService })
    .service({ equipmentService })
    .service({ medicineIncomeService })
    .service({ medicineOutgoService })
    .service({ roleService })
    .service({ sectionService })
    .service({ serviceService })
    .service({ ticketService })

    .name;
