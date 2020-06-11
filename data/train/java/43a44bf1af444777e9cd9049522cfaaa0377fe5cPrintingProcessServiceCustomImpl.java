package com.ppla.app.services.process.custom.impl;

import org.springframework.beans.factory.annotation.Autowired;

import com.ppla.app.models.machine.Printer;
import com.ppla.app.models.process.PrintingProcess;
import com.ppla.app.models.process.QPrintingProcess;
import com.ppla.app.servicebase.custom.AbstractPplaMachineProcessService;
import com.ppla.app.services.machine.PrinterService;
import com.ppla.app.services.process.PrintingProcessService;
import com.ppla.app.services.process.custom.PrintingProcessServiceCustom;
import com.ppla.core.dto.process.PrintingProcessInfo;

/**
 * @author mbmartinez
 */
public class PrintingProcessServiceCustomImpl extends AbstractPplaMachineProcessService<

    PrintingProcess, 
    PrintingProcessInfo, 
    PrintingProcessService,
    Printer,
    PrinterService>

    implements PrintingProcessServiceCustom {

    @Autowired
    private PrintingProcessService service;

    @Override
    public PrintingProcessInfo startInfo(PrintingProcessInfo processInfo) {
        return super.startMachineProcessInfo(processInfo);
    }

    @Override
    public PrintingProcessInfo endInfo(PrintingProcessInfo processInfo) {
        return super.endMachineProcessInfo(processInfo);
    }

    @Override
    public PrintingProcessInfo findInfoByRollTag(String tag) {
        PrintingProcess process = service.findOne(
            QPrintingProcess.printingProcess.rollIn.tag.eq(tag)
        );
        return toDto(process);
    }

}
