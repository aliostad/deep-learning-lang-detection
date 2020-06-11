#ifndef _MODEL_H_
#define _MODEL_H_

#include <stdio.h>
#include "varinfo.h"
#include "heap.h"
#include "common.h"
#include "var.h"

typedef struct _model {
        kvec_t(Literal) model_stack; /* Keeps track of the state of the model */ 
        int last2propagated, last3propagated, lastNpropagated;
        kvec_t(char) assignment; /*truth value of each literal*/
        unsigned int decision_lvl;
        kvec_t(VarInfo) vinfo; /*keeps track of each variable*/
  //        short unsigned int *vassignment;
        Literal dlMarker;
        unsigned int n_vars;
        unsigned int n_lits;
} Model;

void model_set_true_decision(Model *model, Literal l);
void model_set_true_w_reason(Literal l, Reason r, Model *model);

void push(Literal lit, Model *model);
void set_true_in_assignment(Literal lit, Model *model);
void set_undef_in_assignment(Literal lit, Model *model);
void init_in_assignment(Var var, Model *model);
void model_init(unsigned int num_vars, Model *model);

bool model_lit_is_of_current_dl(Literal lit, Model *model);
unsigned int model_get_lit_dl(Literal lit, Model *model);
unsigned int model_get_lit_height(Literal lit, Model *model);
Literal  model_pop_and_set_undef(Model *model);
bool model_is_true(Literal lit, Model *model);
bool model_is_false(Literal lit, Model *model);
bool model_is_undef(Literal lit, Model *model);
bool model_is_true_or_undef(Literal lit, Model *model);
bool model_is_undef_var(Var v, Model *model);
Literal  model_next_lit_for_2_prop(Model *model);
Literal  model_next_lit_for_n_prop(Model *model);
Literal  model_next_lit_for_3_prop(Model *model);
bool model_get_last_phase(Var v, Model *model);
void set_last_phase(Var v, bool phase, Model *model);
Reason model_get_reason_of_lit (Literal lit, Model *model);
bool model_lit_is_decision (Literal lit, Model *model);
void print(Model model);
unsigned int model_size(Model *model);

#endif /* _MODEL_H_ */
