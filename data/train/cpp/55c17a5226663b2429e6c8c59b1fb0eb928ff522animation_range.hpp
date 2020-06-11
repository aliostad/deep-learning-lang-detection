#ifndef SANGUIS_MODEL_ANIMATION_RANGE_HPP_INCLUDED
#define SANGUIS_MODEL_ANIMATION_RANGE_HPP_INCLUDED

#include <sanguis/model/animation_index.hpp>
#include <sanguis/model/animation_range_fwd.hpp>
#include <sanguis/model/symbol.hpp>


namespace sanguis
{
namespace model
{

class animation_range
{
public:
	SANGUIS_MODEL_SYMBOL
	animation_range(
		sanguis::model::animation_index,
		sanguis::model::animation_index
	);

	SANGUIS_MODEL_SYMBOL
	sanguis::model::animation_index
	begin() const;

	SANGUIS_MODEL_SYMBOL
	sanguis::model::animation_index
	end() const;
private:
	sanguis::model::animation_index begin_;

	sanguis::model::animation_index end_;
};

}
}

#endif
