package action;

import javax.annotation.Resource;
import javax.persistence.MappedSuperclass;

import service.ICompressFileService;
import service.ICourseService;
import service.IDocumentService;
import service.IInformationService;
import service.ITypeService;
import service.IUserService;

import com.opensymphony.xwork2.ActionSupport;

@MappedSuperclass
public class ActionTemplate<E> extends ActionSupport {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Resource(name="typeService")
	protected ITypeService typeService ;
	
	@Resource(name="userService")
	protected IUserService userService ;
	
	@Resource(name="informationService")
	protected IInformationService informationService ;
	
	@Resource(name="compressFileService")
	protected ICompressFileService compressFileService ;
	
	@Resource(name="documentService")
	protected IDocumentService documentService ;
	
	protected ICourseService courseService ;

	public ITypeService getTypeService() {
		return typeService;
	}

	public void setTypeService(ITypeService typeService) {
		this.typeService = typeService;
	}

	public void setUserService(IUserService userService) {
		this.userService = userService;
	}

	public void setInformationService(IInformationService informationService) {
		this.informationService = informationService;
	}

	public void setCompressFileService(ICompressFileService compressFileService) {
		this.compressFileService = compressFileService;
	}

	public void setDocumentService(IDocumentService documentService) {
		this.documentService = documentService;
	}

	public void setCourseService(ICourseService courseService) {
		this.courseService = courseService;
	}
	
}
