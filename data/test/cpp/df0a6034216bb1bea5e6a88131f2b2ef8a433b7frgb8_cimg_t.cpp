

// import bug fixed version file
#include "../libs/boost/gil/color_base_algorithm.hpp"
#include "../libs/boost/gil/pixel.hpp"

#include "rgb8_cimg_t.hpp"

#include <typeinfo>


#include <boost/gil/gil_all.hpp>


namespace cimg_library
{

using boost::gil::planar_view_get_raw_data;
using boost::gil::image_view;
using boost::gil::rgb8_image_t;
using boost::gil::rgb8_view_t;
using boost::gil::rgb8c_view_t;
using boost::gil::rgb8_planar_image_t;
using boost::gil::rgb8_planar_view_t;




/*
//typedef boost::gil::memory_based_2d_locator<boost::gil::memory_based_step_iterator<boost::gil::pixel<unsigned char, boost::gil::layout<boost::mpl::vector3<boost::gil::red_t, boost::gil::green_t, boost::gil::blue_t>, boost::mpl::range_c<int, 0, 3> > > const*> > locator_type_a;
template void gil_cimg_t::assign<rgb8_view_t::locator>(image_view<rgb8_view_t::locator> &);
template void gil_cimg_t::assign<rgb8c_view_t::locator>(image_view<rgb8c_view_t::locator> &);
template void gil_cimg_t::assign<rgb8_planar_view_t::locator>(image_view<rgb8_planar_view_t::locator> &);
//template void rgb8_cimg_t::assign<locator_type_a>(image_view<locator_type_a> &);


template void gil_cimg_t::operator=<rgb8_view_t::locator>(image_view<rgb8_view_t::locator> &);
template void gil_cimg_t::operator=<rgb8c_view_t::locator>(image_view<rgb8c_view_t::locator> &);
template void gil_cimg_t::operator=<rgb8_planar_view_t::locator>(image_view<rgb8_planar_view_t::locator> &);
//template void rgb8_cimg_t::operator=<locator_type_a>(image_view<locator_type_a> &);
*/

}
