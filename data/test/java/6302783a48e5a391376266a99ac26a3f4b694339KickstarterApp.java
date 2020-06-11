package com.morkva;

import com.morkva.logic.Printer;
import com.morkva.logic.Reader;
import com.morkva.model.CategoryRepository;
import com.morkva.model.PaymentOptionRepository;
import com.morkva.model.ProjectRepository;
import com.morkva.model.QuoteRepository;

public class KickstarterApp {

    private CategoryRepository categoryRepository;
    private ProjectRepository projectRepository;
    private QuoteRepository quoteRepository;
    private PaymentOptionRepository paymentOptionRepository;

    private Reader reader;
	private Printer printer;
    
    public KickstarterApp(Printer printer, Reader reader) {
    	this.printer = printer;
        this.reader = reader;
	}

    
    public void run() {
        showQuote();
        //Model model = new Model(categoryRepository, projectRepository, paymentOptionRepository);
        //ViewHelper viewHelper = new ViewHelper(model, printer, reader);
        //ViewResolver.getInstance().setNextView(new LoginController(model, printer, reader));
        //viewHelper.runCommand();
    }


    private void showQuote() {
        println(quoteRepository.getRandomQuote());
    }
    
    public void print(Object o) {
    	printer.print(o);
    }
    
    public void println(Object o) {
    	print(o + "\n");
    }

    public void setCategoryRepository(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    public void setProjectRepository(ProjectRepository projectRepository) {
        this.projectRepository = projectRepository;
    }

    public void setPaymentOptionRepository(PaymentOptionRepository paymentOptionRepository) {
        this.paymentOptionRepository = paymentOptionRepository;
    }

    public void setQuoteRepository(QuoteRepository quoteRepository) {
        this.quoteRepository = quoteRepository;
    }

//    public void setUserRepository(Repository<User> userRepository) {
//        this.userRepository = userRepository;
//    }
}
