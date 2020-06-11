/**
 * \file dcs/perfeval/energy/any_model.hpp
 *
 * \brief Generic class for energy models implementing the EnergyModel concept.
 *
 * Copyright (C) 2009-2010  Distributed Computing System (DCS) Group, Computer
 * Science Department - University of Piemonte Orientale, Alessandria (Italy).
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * \author Marco Guazzone (marco.guazzone@gmail.com)
 */

#ifndef DCS_PERFEVAL_ANY_MODEL_HPP
#define DCS_PERFEVAL_ANY_MODEL_HPP


#include <dcs/perfeval/energy/base_model.hpp>
#include <dcs/perfeval/energy/model_adaptor.hpp>
#include <dcs/memory.hpp>
#include <dcs/type_traits/remove_reference.hpp>
#include <dcs/util/holder.hpp>


namespace dcs { namespace perfeval { namespace energy {

/**
 * \brief Class for any energy models implementing the EnergyModel concept.
 *
 * \tparam RealT The type for real numbers.
 *
 * \author Marco Guazzone (marco.guazzone@gmail.com)
 */
template <typename RealT>
struct any_model
{
	//[TODO]
	//DCS_CONCEPT_ASSERT((EnergyModel<any_model<RealT>))
	//[/TODO]


	/// Alias for the type of real numbers.
	public: typedef RealT real_type;


	/// Default constructor.
	public: any_model()
	{
		// empty
	}


	/*
	 * \brief Wrap a concrete energy model.
	 * \tparam EnergyModelT The concrete energy model type.
	 */
	public: template <typename EnergyModelT>
		any_model(EnergyModelT const& model)
		: ptr_model_(new model_adaptor<EnergyModelT>(model))
	{
		// empty
	}


	/*
	 * \brief Wrap a concrete energy model.
	 * \tparam EnergyModelT The concrete energy model type.
	 *
	 * This is used for example when you want to pass a reference value instead
	 * of a const reference value.
	 */
	public: template <typename EnergyModelT>
		//any_model(EnergyModelT& model) // don't work
		any_model(::dcs::util::holder<EnergyModelT> const& wrap_model)
		: ptr_model_(new model_adaptor<EnergyModelT>(wrap_model.get()))
	{
		// empty
	}


	// Set a new energy model.
	public: template <typename EnergyModelT>
		void model(EnergyModelT const& model)
	{
		ptr_model_ = new model_adaptor<EnergyModelT>(model);
	}


	/**
	 * \brief Compute the energy consumed for the given system utilization.
	 * \param u The system utilization.
	 * \return The energy consumed for the given system utilization.
	 */
	public: real_type consumed_energy(real_type u) const
	{
		return ptr_model_->consumed_energy(u);
	}


	private: ::dcs::shared_ptr< base_model<real_type> > ptr_model_; // shared_ptr needed in order to keep alive the pointer during object copying
};


template <typename EnergyModelT, typename EnergyModelTraitsT=typename ::dcs::type_traits::remove_reference<EnergyModelT>::type>
struct make_any_model_type
{
	typedef any_model<typename EnergyModelTraitsT::real_type> type;
};


namespace detail {

template <typename EnergyModelT, typename EnergyModelTraitsT=typename ::dcs::type_traits::remove_reference<EnergyModelT>::type>
struct make_any_model_impl;


template <typename EnergyModelT, typename EnergyModelTraitsT>
struct make_any_model_impl
{
	typedef typename make_any_model_type<EnergyModelT,EnergyModelTraitsT>::type any_model_type;
	static any_model_type apply(EnergyModelT& model)
	{
		return any_model_type(model);
	}
};


template <typename EnergyModelT, typename EnergyModelTraitsT>
struct make_any_model_impl<EnergyModelT&,EnergyModelTraitsT>
{
	typedef typename make_any_model_type<EnergyModelT,EnergyModelTraitsT>::type any_model_type;
	static any_model_type apply(EnergyModelT& model)
	{
		::dcs::util::holder<EnergyModelT&> wrap_model(model);
		return any_model_type(wrap_model);
	}
};

} // Namespace detail


template <typename EnergyModelT>
typename make_any_model_type<EnergyModelT>::type make_any_model(EnergyModelT model)
{
	return detail::make_any_model_impl<EnergyModelT>::apply(model);
}

}}} // Namespace dcs::perfeval::energy


#endif // DCS_PERFEVAL_ANY_MODEL_HPP
