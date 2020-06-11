/**
 * This work is licensed under the Creative Commons
 * Attribution-NonCommercial 3.0 Unported License. To view a copy of this
 * license, visit http://creativecommons.org/licenses/by-nc/3.0/ or send a
 * letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View,
 * California, 94041, USA.
 */
/**
 * @file repo_base.cpp
 * @date 19.06.2009
 * @author gerd
 */

#include "repo_base.h"

namespace repo
{

_Repo_base::_Repo_base() :
	C_(0), N_(0), nStored_(0), minID_(0), maxID_(0)
{
	_init();
}

_Repo_base::_Repo_base(category_t cat) :
	C_(cat), N_(100), nStored_(0), count_(cat + 1, 0), offset_(cat + 1, 0),
			nums_(N_, 0), ids_(N_, 0), minID_(0), maxID_(0)
{
	assert(C_ > 0);
	_init();
}

_Repo_base::_Repo_base(const category_t cat, const id_size_t n) :
	C_(cat), N_(n), nStored_(0), count_(cat + 1, 0), offset_(cat + 1, 0),
			nums_(N_, 0), ids_(N_, 0), minID_(0), maxID_(0)
{
	_init();
}

_Repo_base::_Repo_base(const _Repo_base& r) :
	C_(r.C_), N_(r.nStored_), count_(C_ + 1, 0), offset_(C_ + 1, 0)
{
	_init();
}

_Repo_base::~_Repo_base()
{
}

void _Repo_base::_init()
{
	nStored_ = 0;
	nums_.reserve(N_);
	nums_.resize(N_, 0);
	ids_.reserve(N_);
	ids_.resize(N_, 0);
	count_.reserve(C_ + 1);
	count_.resize(C_ + 1, 0);
	offset_.reserve(C_ + 1);
	offset_.resize(C_ + 1, 0);
	for (unsigned int i = 0; i < N_; ++i)
	{
		ids_[i] = i;
		nums_[i] = i;
	}
	for (unsigned int i = 0; i < C_; ++i)
	{
		count_[i] = 0;
		offset_[i] = 0;
	}
	offset_[C_] = 0;
	count_[C_] = N_;
	minID_ = 0;
	maxID_ = 0;
}

}
