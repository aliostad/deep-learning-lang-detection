/**
 * 
 */
package nuclei.service;

import nuclei.domain.Member;
import nuclei.repository.MemberRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.neo4j.repository.GraphRepository;
import org.springframework.stereotype.Service;

/**
 * @author Sathish
 *
 */
@Service("memberService")
public class MemberServiceImpl extends GenericService<Member> implements MemberService {

	@Autowired
    private MemberRepository repository;

    @Override
    public GraphRepository<Member> getRepository() {
        return repository;
    }
}
