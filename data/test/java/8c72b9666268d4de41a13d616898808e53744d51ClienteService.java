package edu.wary.despacho.service;

import java.util.List;

import javax.management.RuntimeErrorException;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;



import edu.wary.model.Almacen;
import edu.wary.model.Destinatario;
import edu.wary.model.Encomienda;
import edu.wary.model.Cliente;
import edu.wary.model.Incidencia;
import edu.wary.model.Pago;
import edu.wary.model.Remitente;
import edu.wary.model.repository.AlmacenRepository;
import edu.wary.model.repository.DestinatarioRepository;
import edu.wary.model.repository.EncomiendaRepository;



import edu.wary.model.repository.ClienteRepository;
import edu.wary.model.repository.IncidenciaRepository;
import edu.wary.model.repository.PagoRepository;
import edu.wary.model.repository.RemitenteRepository;
import edu.wary.util.Utilitario;

@SuppressWarnings("unused")
public class ClienteService {
	private DestinatarioRepository destinatarioRepository;
	private EncomiendaRepository encomiendaRepository;
	private PagoRepository pagoRepository;
	private RemitenteRepository remiRepository;
	private AlmacenRepository almacenRepository;
	private IncidenciaRepository incidenciaRepository;
	
	private ClienteRepository clienteRepository;
	
	
	private EntityManager em;
	
	
	
	public ClienteService() {
		em=Utilitario.getInstance().getEntityManager();
		destinatarioRepository=new DestinatarioRepository(em);
		encomiendaRepository=new EncomiendaRepository(em);
		pagoRepository=new PagoRepository(em);
		remiRepository=new RemitenteRepository(em);
		almacenRepository=new AlmacenRepository(em);
		incidenciaRepository= new IncidenciaRepository(em);
		clienteRepository= new ClienteRepository(em);
	}

	

	public Cliente buscarClienteSt(String id){
		
		return clienteRepository.findById(id);
	}
	
	
	public Cliente buscarClienteOb(Cliente e)throws RuntimeException{
		
		ClienteRepository clienteRepository=new ClienteRepository(em);
		
		Cliente clientebd=clienteRepository.findById(String.valueOf(e.getNrodoc()));
		
		if (clientebd.getNrodoc()!=e.getNrodoc()) {
			throw new RuntimeException("Cliente no encontrado");
		}
		return clientebd;
	}
	
	public Cliente buscarCliente(int id){
		
		Cliente clientebd=clienteRepository.findById(id);
		
		return clientebd;
	}
		
	
}
