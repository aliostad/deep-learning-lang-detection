package apollo.spi;

import apollo.BasicService;
import apollo.ClipboardService;
import apollo.FileOpenService;
import apollo.FileSaveService;
import apollo.PersistenceService;
import apollo.PrintService;

public interface ServiceResolver {
    public BasicService lookupBasicService();

    public ClipboardService lookupClipboardService();

    public FileOpenService lookupFileOpenService();

    public FileSaveService lookupFileSaveService();

    public PrintService lookupPrintService();

    public PersistenceService lookupPersistenceService();
}