package Control;

import java.util.List;

import Dominio.Perfil;
import Dominio.Permissao;
import Interfaces.IPerfilRepository;
import Interfaces.IPermissaoRepository;
import Repositories.PerfilRepository;
import Repositories.PermissaoRepository;

public class PerfilControl {

	private IPerfilRepository perfilRepository;
	private IPermissaoRepository permissaoRepository;

	public PerfilControl() {
		perfilRepository = new PerfilRepository();
		permissaoRepository = new PermissaoRepository();
	}

	public List<Perfil> listarTodos() {
		return perfilRepository.findAll();
	}

	public Perfil buscarPerfil(int id) {
		return perfilRepository.find(id);
	}

	public boolean cadastrar(Perfil perfil) {
		return perfilRepository.add(perfil);
	}

	public boolean atualizar(Perfil perfil) {
		return perfilRepository.update(perfil);
	}

	public List<Permissao> ListarTodos(long idPerfil) {
		return permissaoRepository.findAll(idPerfil);
	}

}
