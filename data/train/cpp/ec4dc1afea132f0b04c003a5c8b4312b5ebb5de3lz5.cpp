//****************************************************************************************************
//* lz5.cpp                                                                                          *
//*                                                                                                  *
//* Copyright (c) 2008 LuCCA-Z (Laboratório de Computação Científica Aplicada à Zootecnia),     *
//* Rodovia Comandante João Ribeiro de Barros (SP 294), km 651. UNESP,                              *
//* Dracena, São Paulo, Brazil, 17900-000                                                           *
//*                                                                                                  *
//* This file is part of LZ5.                                                                        *
//*                                                                                                  *
//* LZ5 is free software: you can redistribute it and/or modify it under the terms of the            *
//* GNU General Public License as published by the Free Software Foundation, either version 3        *
//* of the License, or (at your option) any later version.                                           *
//*                                                                                                  *
//* LZ5 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without         *
//* even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See            *
//* the GNU General Public License for more details. You should have received a copy of the          *
//* GNU General Public License along with LZ5. If not, see <http://www.gnu.org/licenses/>.           *
//*                                                                                                  *
//* Acknowledgements                                                                                 *
//*                                                                                                  *
//* To Dr. Rohan L. Fernando from Iowa State University and Dr. Ricardo Frederico Euclydes           *
//* from Vicosa Federal University, who had great influence in ideas behind the LZ5's development.   *
//*                                                                                                  *
//****************************************************************************************************

// TODO: pensar em elaborar funções para método interativo e sobrecarregar para método de comandos, o qual normalmente necessita de menos argumento e não deve acessar a classe parameters.
// TODO: reformular interface de forma que os objetos possam ser criados durante a execução do programa.
// TODO: pensar se a classe parameters deve agir somente como uma interface e distribuir os parâmetros recebidos para os respectivos objetos. Verificar se funciona. Esse esquema evitaria duplicação de informações.

#include <gsl/gsl_rng.h>
#include "parameters.h"
#include "prompt.h"
#include "population.h"
#include "ranSel.h"
#include "indSel.h"
#include "baseReport.h"
#include "parRepo.h"
#include "indSelRepo.h"
#include "tandemRepo.h"
#include "popRepo.h"
#include "indRepo.h"
#include "genomeRepo.h"
#include "repSim.h"
#include "tandem.h"

using lz5::Prompt;
using lz5::Lz5_Interpreter;
using simulation::Parameters;
using simulation::Population;
using simulation::Population1;
using selection::RanSel;
using selection::IndSel;
using report::BaseReport; 
using report::ParRepo;
using report::IndSelRepo;
using report::TandemRepo;
using report::PopRepo;
using report::IndRepo;
using report::GenomeRepo;
using simulation::RepSim;
using simulation::RepSim1;
using selection::Tandem;

gsl_rng* prand = gsl_rng_alloc(gsl_rng_mt19937);

int main(){
  gsl_rng_set(prand,time(0));

  Prompt promptObject;
  Lz5_Interpreter interp;
  interp.readcomm("commands.lz5");
  lz5_Result_Struct lrs;
  string prompt;  
  Parameters par;
  par.setName("par");

  Population pop(par);
  pop.setName("pop");
  Population1 pop1(par);
  pop1.setName("pop1");
  
  RanSel rs;
  rs.setName("rs");
  IndSel indsel;
  indsel.setName("indsel");

  Tandem td;
  td.setName("td");

  ParRepo parRepo;
  parRepo.setName("parRepo");
  
  IndSelRepo iSelRepo;
  iSelRepo.setName("iSelRepo");
  
  TandemRepo tdRepo;
  tdRepo.setName("tdRepo");

  PopRepo popRepo;
  popRepo.setName("popRepo");
 
  IndRepo indRepo;
  indRepo.setName("indRepo");
 
  GenomeRepo genomeRepo;
  genomeRepo.setName("genomeRepo");
  
  RepSim repSim;
  repSim.setName("repSim");
  RepSim1 repSim1;
  repSim1.setName("repSim1");
  
  while(true){
    prompt=promptObject.get("(lz5)> ");
    if(prompt=="quit"||prompt=="quit()"){return 0;}    
    lrs = interp.verify(prompt);
    par.exec(lrs);
    pop.exec(lrs,par);
    pop1.exec(lrs,par);
    indsel.exec(lrs,pop);
    parRepo.exec(lrs,par);
    //iSelRepo.exec(lrs,indsel,par);
    tdRepo.exec(lrs,td);
    popRepo.exec(lrs,pop,par);
    indRepo.exec(lrs,pop,par);
    genomeRepo.exec(lrs,par);
    repSim.exec(lrs,pop,indsel,par,popRepo);
    td.exec(lrs,par,pop);
  }  
  return 0;
}
