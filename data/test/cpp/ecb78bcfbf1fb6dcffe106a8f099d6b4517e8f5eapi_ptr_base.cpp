/*
 * api_ptr_base.cpp
 *
 * Copyright TUD 2013
 * Alle Rechte vorbehalten. All rights reserved
 */
#include "stdafx.h"
#include "rivlib/api_ptr_base.h"
#include "node.h"
#include "the/assert.h"

using namespace eu_vicci::rivlib;


/*
 * api_ptr_base::api_ptr_base
 */
api_ptr_base::api_ptr_base(void) : obj() {
    // intentionally empty
}


/*
 * api_ptr_base::api_ptr_base
 */
api_ptr_base::api_ptr_base(node_base *o) : obj() {
    if (o != nullptr) {
        node *n = dynamic_cast<node*>(o);
        THE_ASSERT(n != nullptr);
        this->obj = n->get_api_ptr();
    }
}


/*
 * api_ptr_base::api_ptr_base
 */
api_ptr_base::api_ptr_base(const api_ptr_base& src) : obj(src.obj) {
    // intentionally empty
}


/*
 * api_ptr_base::~api_ptr_base
 */
api_ptr_base::~api_ptr_base(void) {
    // intentionally empty
}


/*
 * api_ptr_base::get
 */
node_base* api_ptr_base::get(void) {
    return this->obj.get();
}


/*
 * api_ptr_base::get
 */
const node_base* api_ptr_base::get(void) const {
    return this->obj.get();
}


/*
 * api_ptr_base::reset
 */
void api_ptr_base::reset(void) {
    this->obj.reset();
}


/*
 * api_ptr_base::operator =
 */
api_ptr_base& api_ptr_base::operator =(const api_ptr_base& rhs) {
    if (this != &rhs) {
        this->obj = rhs.obj;
    }
    return *this;
}


/*
 * api_ptr_base::operator==
 */
bool api_ptr_base::operator==(const api_ptr_base& rhs) const {
    return this->obj == rhs.obj;
}


/*
 * api_ptr_base::operator!=
 */
bool api_ptr_base::operator!=(const api_ptr_base& rhs) const {
    return !(this->obj == rhs.obj);
}


/*
 * api_ptr_base::operator bool
 */
api_ptr_base::operator bool(void) const {
    return static_cast<bool>(this->obj);
}
