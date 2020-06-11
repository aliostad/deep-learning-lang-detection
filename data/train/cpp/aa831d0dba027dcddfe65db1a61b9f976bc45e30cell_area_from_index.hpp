#ifndef SANGUIS_MODEL_CELL_AREA_FROM_INDEX_HPP_INCLUDED
#define SANGUIS_MODEL_CELL_AREA_FROM_INDEX_HPP_INCLUDED

#include <sanguis/model/animation_index.hpp>
#include <sanguis/model/cell_area.hpp>
#include <sanguis/model/cell_size_fwd.hpp>
#include <sanguis/model/image_size_fwd.hpp>
#include <sanguis/model/symbol.hpp>


namespace sanguis
{
namespace model
{

SANGUIS_MODEL_SYMBOL
sanguis::model::cell_area
cell_area_from_index(
	sanguis::model::image_size,
	sanguis::model::cell_size,
	sanguis::model::animation_index
);

}
}

#endif
