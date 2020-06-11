#include "loadwindow.h"

#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QLabel>

LoadWindow::LoadWindow(): QWidget()
{
	#if DEBUG_CREA_FORET
	cout<< "Chargement d'une foret à partir d'un fichier "<< endl;
	#endif
	#if DEBUG_LOAD
	cout<< "Taille : " << largeur<< " en largeur "<< hauteur<< " en hauteur" <<endl;
	#endif
	
	resize(400, 30);
	QVBoxLayout* layLoad= new QVBoxLayout(this);
	
	QLabel* txtLoad= new QLabel("Chargement de la foret");
	PB_load= new QProgressBar();
	
	layLoad->addWidget(txtLoad);
	layLoad->addWidget(PB_load);

	show();
}

LoadWindow::~LoadWindow()
{
	delete PB_load;
}

void LoadWindow::setProgress(int pourcentage)
{
	PB_load->setValue(pourcentage);
}

void LoadWindow::closeProgress()
{
	hide();
	delete PB_load;
}