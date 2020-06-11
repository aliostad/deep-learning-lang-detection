#include "smartgriddata.h"

SmartGridData::SmartGridData(){ //ctor
}

SmartGridData::SmartGridData(string s){ //ctor
	vector<int> tarif_selang;
	ifstream fileInput;
	Barang *br;
	unsigned int i, slot, release, deadline, priority, n_slot;
	int j, k, l, x;
	float xf, kWh;
	string name, wajib;
	char dump;

	fileInput.open(s.c_str());

	//read first line
	fileInput >> slot_waktu;
	fileInput >> dump;
	fileInput >> selang_tarif;
	fileInput >> dump;
	fileInput >> n_progresif;
	fileInput >> dump;
	fileInput >> kWh_max;

	//read n_progresif, set selang
	for (i=0; i<2; i++){
		fileInput >> x;
		selang.push_back(x);
		fileInput >> dump;
	}
	fileInput >> xf;
    kWh_mark.push_back(xf);
	fileInput >> dump;
	fileInput >> x;
	tarif_selang.push_back(x);
	fileInput >> dump;

	for(l=1; l<selang_tarif; l++){
		for (i=0; i<2; i++){
			fileInput >> x;
			selang.push_back(x);
			fileInput >> dump;
		}
		fileInput >> xf;
		fileInput >> dump;
		fileInput >> x;
		tarif_selang.push_back(x);
		fileInput >> dump;
	}
	tarif.push_back(tarif_selang);
	tarif_selang.clear();

	//read n_progresif
	for (j=1; j<n_progresif; j++){
		for (k=0; k<2; k++){
			fileInput >> x;
			fileInput >> dump;
		}
		fileInput >> xf;
        kWh_mark.push_back(xf);
		fileInput >> dump;
		fileInput >> x;
		tarif_selang.push_back(x);
		fileInput >> dump;
		for (l=1; l<selang_tarif; l++){
			for (k=0; k<2; k++){
				fileInput >> x;
				fileInput >> dump;
			}
			fileInput >> x;
			fileInput >> dump;
			fileInput >> x;
			tarif_selang.push_back(x);
			fileInput >> dump;
		}
		tarif.push_back(tarif_selang);
		tarif_selang.clear();
	}
	fileInput >> n_barang;
	br = new Barang[n_barang];
	fileInput.get(dump);

	//ignore
	for (j=0; j<n_barang; j++){
		fileInput >> dump;
		while ((dump=='\n') || (dump=='.') || (dump=='\0') || (dump==' ')) {
			fileInput.get(dump);
		}
		name.clear();
		while (dump!=','){
			name += dump;
			fileInput.get(dump);
		}
		fileInput >> kWh;
		fileInput >> dump;
		fileInput >> slot;
		fileInput >> dump;
		fileInput >> release;
		fileInput >> dump;
		fileInput >> deadline;
		fileInput >> dump;
		while ((dump=='\n') || (dump=='.') || (dump=='\0') || (dump==' ')) {
			fileInput.get(dump);
		}
		wajib.clear();
		fileInput >> dump;
		while(dump!=','){
			wajib += dump;
			fileInput.get(dump);
		}
		if (wajib.compare("wajib") == 0){
			priority = 1;
		} else{
			priority = 0;
		}
		fileInput >> n_slot;
		fileInput >> dump;
        br[i].Setter(name, kWh, slot, n_slot, release, deadline, priority, slot_waktu);
		l_barang.push_back(br[i]);
	}
	fileInput.close();
}

SmartGridData::~SmartGridData(){ //dtor
}

int SmartGridData::Getslot_waktu(){
	return slot_waktu;
}

int SmartGridData::Getselang_tarif(){
	return selang_tarif;
}

int SmartGridData::Getn_progresif(){
	return n_progresif;
}

int SmartGridData::Getn_barang(){
	return n_barang;
}

float SmartGridData::GetkWh_max(){
	return kWh_max;
}

vector<vector<int> > SmartGridData::Gettarif(){
	return tarif;
}

vector<int> SmartGridData::Getselang(){
	return selang;
}

vector<float> SmartGridData::GetkWh_mark(){
	return kWh_mark;
}

vector<Barang> SmartGridData::Getl_barang(){
	return l_barang;
}
