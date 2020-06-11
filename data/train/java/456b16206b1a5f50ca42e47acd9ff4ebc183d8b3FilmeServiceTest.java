package br.com.gabrielrubens.filme.service;

import static org.mockito.Matchers.anyCollectionOf;
import static org.mockito.Mockito.verify;

import org.junit.Test;
import org.mockito.Mockito;

import br.com.gabrielrubens.filme.model.Filme;
import br.com.gabrielrubens.filme.repository.FilmeRepository;
import br.com.gabrielrubens.filme.repository.FilmeRepositoryImpl;
import br.com.gabrielrubens.filme.repository.UsuarioRepository;
import br.com.gabrielrubens.filme.repository.UsuarioRepositoryImpl;
import br.com.gabrielrubens.filme.repository.VotoRepository;
import br.com.gabrielrubens.filme.repository.VotoRepositoryImpl;

public class FilmeServiceTest {

	@Test
	public void deveCriar5Filmes() {
		VotoRepository votoRepository = Mockito.mock(VotoRepositoryImpl.class);
		FilmeRepository filmeRepository = Mockito.mock(FilmeRepositoryImpl.class);
		UsuarioRepository usuarioRepository = Mockito.mock(UsuarioRepositoryImpl.class);
		FilmeService service = new FilmeService(votoRepository, filmeRepository, usuarioRepository);

		service.inserirBaseDeTeste();
		
		verify(votoRepository).removeAll();
		verify(filmeRepository).removeAll();
		verify(filmeRepository).insertAll(anyCollectionOf(Filme.class));
	}
}
