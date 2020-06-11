#ifndef DCS_DES_CLOUD_CONFIG_OPERATION_MAKE_ENERGY_MODEL_HPP
#define DCS_DES_CLOUD_CONFIG_OPERATION_MAKE_ENERGY_MODEL_HPP


#include <boost/variant.hpp>
#include <dcs/des/cloud/config/energy_model.hpp>
#include <dcs/memory.hpp>
#include <dcs/perfeval/energy.hpp>


namespace dcs { namespace des { namespace cloud { namespace config {

template <typename RealT, typename VariantT>
::dcs::shared_ptr<
	::dcs::perfeval::energy::base_model<RealT>
> make_energy_model(energy_model_category category,
					VariantT const& variant_config)
{
	typedef ::dcs::perfeval::energy::base_model<RealT> base_model_type;

	::dcs::shared_ptr<base_model_type> ptr_model;

	switch (category)
	{
		case constant_energy_model:
			{
				typedef constant_energy_model_config<RealT> model_config_type;
				typedef ::dcs::perfeval::energy::constant_model<RealT> model_type;
				model_config_type const& model = ::boost::get<model_config_type>(variant_config);
				ptr_model = ::dcs::make_shared<model_type>(model.c0);
			}
			break;
		case fan2007_energy_model:
			{
				typedef fan2007_energy_model_config<RealT> model_config_type;
				typedef ::dcs::perfeval::energy::fan2007_model<RealT> model_type;
				model_config_type const& model = ::boost::get<model_config_type>(variant_config);
				ptr_model = ::dcs::make_shared<model_type>(
							model.c0,
							model.c1,
							model.c2,
							model.r
					);
			}
			break;
	}

	return ptr_model;
}

}}}} // Namespace dcs::des::cloud::config


#endif // DCS_DES_CLOUD_CONFIG_OPERATION_MAKE_ENERGY_MODEL_HPP
