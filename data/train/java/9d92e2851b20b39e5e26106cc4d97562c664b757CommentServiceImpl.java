package madvirus.spring.appa;

import java.util.List;

public class CommentServiceImpl implements CommentService {

	private CommentRepository commentRepository;

	@Override
	public Comment write(Comment comment) {
		return commentRepository.save(comment);
	}
	
	@Override
	public List<Comment> list() {
		return commentRepository.findAll();
	}

	public String getName() {
		return "CommentServiceImpl";
	}
	
	public void setCommentRepository(CommentRepository commentRepository) {
		this.commentRepository = commentRepository;
	}

}
