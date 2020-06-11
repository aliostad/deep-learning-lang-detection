package isteklifsistemi.service;

import isteklifsistemi.model.Talep;
import isteklifsistemi.model.Teklif;
import isteklifsistemi.repository.TalepRepository;
import isteklifsistemi.repository.TeklifRepository;
import org.springframework.stereotype.Service;

/**
 * Created by alpay on 5/20/17.
 */

@Service
public class TeklifKatalogu {

    private TalepRepository talepRepository;
    private TeklifRepository teklifRepository;

    public TeklifKatalogu(TeklifRepository teklifRepository, TalepRepository talepRepository) {
        this.teklifRepository = teklifRepository;
        this.talepRepository = talepRepository;
    }

    public Teklif save(Teklif teklif) {
        return teklifRepository.save(teklif);
    }

    public Teklif findOne(long id) {
        return teklifRepository.findOne(id);
    }

    public Iterable<Teklif> findAll() {
        return teklifRepository.findAll();
    }

    public void delete(long id) {
        teklifRepository.delete(id);
    }
}
