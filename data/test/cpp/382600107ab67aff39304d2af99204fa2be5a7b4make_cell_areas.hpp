#ifndef SANGUIS_MODEL_MAKE_CELL_AREAS_HPP_INCLUDED
#define SANGUIS_MODEL_MAKE_CELL_AREAS_HPP_INCLUDED

#include <sanguis/model/animation_range_fwd.hpp>
#include <sanguis/model/cell_area_container.hpp>
#include <sanguis/model/cell_size_fwd.hpp>
#include <sanguis/model/image_size_fwd.hpp>
#include <sanguis/model/symbol.hpp>


namespace sanguis
{
namespace model
{

SANGUIS_MODEL_SYMBOL
sanguis::model::cell_area_container
make_cell_areas(
	sanguis::model::image_size,
	sanguis::model::cell_size,
	sanguis::model::animation_range
);

}
}

#endif
