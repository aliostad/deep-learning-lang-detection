package com.aldercape.internal.economics.persistence;

import java.io.File;

import com.aldercape.internal.economics.model.ClientRepository;
import com.aldercape.internal.economics.model.CollaboratorRepository;
import com.aldercape.internal.economics.model.InvoiceEntryRepository;
import com.aldercape.internal.economics.model.InvoiceRepository;
import com.aldercape.internal.economics.model.TimeEntryRepository;

public class __FileSystemRepositories {

	private InvoiceRepository invoiceRepository;
	private InvoiceEntryRepository invoiceEntryRepository;
	private CollaboratorRepository collaboratorRepository;
	private ClientRepository clientRepository;
	private TimeEntryRepository timeEntryRepository;

	public __FileSystemRepositories(File baseDir) {
		RepositoryRegistry repositoryRegistry = new RepositoryRegistry();

		collaboratorRepository = new CollaboratorFileSystemRepository(new File(baseDir, "collaborators.json"));
		repositoryRegistry.setRepository(CollaboratorRepository.class, collaboratorRepository);

		clientRepository = new ClientFileSystemRepository(new File(baseDir, "clients.json"));
		repositoryRegistry.setRepository(ClientRepository.class, clientRepository);

		timeEntryRepository = new TimeEntryFileSystemRepository(new File(baseDir, "timeEntries.json"), repositoryRegistry);
		repositoryRegistry.setRepository(TimeEntryRepository.class, timeEntryRepository);

		invoiceEntryRepository = new InvoiceEntryFileSystemRepository(new File(baseDir, "invoiceEntries.json"), repositoryRegistry);
		repositoryRegistry.setRepository(InvoiceEntryRepository.class, invoiceEntryRepository);

		invoiceRepository = new InvoiceFileSystemRepository(new File(baseDir, "invoices.json"), repositoryRegistry);
		repositoryRegistry.setRepository(InvoiceRepository.class, invoiceRepository);
	}

	public InvoiceRepository invoiceRepository() {
		return invoiceRepository;
	}

	public InvoiceEntryRepository invoiceEntryRepository() {
		return invoiceEntryRepository;
	}

	public CollaboratorRepository collaboratorRepository() {
		return collaboratorRepository;
	}

	public ClientRepository clientRepository() {
		return clientRepository;
	}

	public TimeEntryRepository timeEntryRepository() {
		return timeEntryRepository;
	}
}
