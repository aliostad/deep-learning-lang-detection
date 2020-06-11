//! \file eggs/tupleware/invoke.hpp
// Eggs.Tupleware
//
// Copyright Agustin K-ballo Berge, Fusion Fenix 2014
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

#ifndef EGGS_TUPLEWARE_INVOKE_HPP
#define EGGS_TUPLEWARE_INVOKE_HPP

#include <eggs/tupleware/core.hpp>
#include <eggs/tupleware/detail/invoke.hpp>

namespace eggs { namespace tupleware
{
    namespace meta
    {
        //! \brief Invokes a \ref placeholder_expression with the given
        //! arguments
        //!
        //! \see \link invoke(F&&, Args&&...) \endlink,
        //!      \link invoke(F&&, expand_tuple_t, Args&&) \endlink,
        //!      \link result_of::invoke \endlink,
        //!      \link result_of::invoke_t \endlink,
        //!      \link functional::invoke \endlink
        template <typename LambdaExpression, typename ...Args>
        struct invoke
          : detail::meta::invoke<LambdaExpression, pack<Args...>>
        {};
    }

    ///////////////////////////////////////////////////////////////////////////
    namespace result_of
    {
        //! \brief Result type of an invocation of \ref invoke(F&&, Args&&...)
        //!
        //! \see \link meta::invoke \endlink,
        //!      \link invoke(F&&, Args&&...) \endlink,
        //!      \link invoke(F&&, expand_tuple_t, Args&&) \endlink,
        //!      \link result_of::invoke_t \endlink,
        //!      \link functional::invoke \endlink
        template <typename F, typename ...Args>
        struct invoke
          : detail::_result_of_invoke<
                F, Args...
            >
        {};

        //! \brief Result type of an invocation of
        //! \ref invoke(F&&, expand_tuple_t, Args&&)
        //!
        //! \see \link meta::invoke \endlink,
        //!      \link invoke(F&&, Args&&...) \endlink,
        //!      \link invoke(F&&, expand_tuple_t, Args&&) \endlink,
        //!      \link result_of::invoke_t \endlink,
        //!      \link functional::invoke \endlink
        template <typename F, typename Args>
        struct invoke<F, expand_tuple_t, Args>
          : detail::_result_of_invoke<
                F, expand_tuple_t, Args
            >
        {};

        //! \brief Alias for \link result_of::invoke \endlink
        //!
        //! \see \link meta::invoke \endlink,
        //!      \link invoke(F&&, Args&&...) \endlink,
        //!      \link invoke(F&&, expand_tuple_t, Args&&) \endlink,
        //!      \link result_of::invoke \endlink,
        //!      \link functional::invoke \endlink
        template <typename F, typename ...Args>
        using invoke_t =
            typename invoke<F, Args...>::type;
    }

    //! \brief Invokes a callable with the given arguments
    //!
    //! \details
    //!
    //! - `(arg1.*f)(arg2, ..., argN)` when `f` is a pointer to a member
    //!   function of a class `T` and `arg1` is an object of type `T` or a
    //!   reference to an object of type `T` or a reference to an object of a
    //!   type derived from `T`;
    //!
    //! - `((*arg1).*f)(arg2, ..., argN)` when `f` is a pointer to a member
    //!   function of a class `T` and `arg1` is not one of the types described
    //!   in the previous item;
    //!
    //! - `arg1.*f` when `sizeof...(Args) == 1` and `f` is a pointer to member
    //!   data of a class `T` and `arg1` is an object of type `T` or a
    //!   reference to an object of type `T` or a reference to an object of a
    //!   type derived from `T`;
    //!
    //! - `(*arg1).*f` when `sizeof...(Args) == 1` and `f` is a pointer to
    //!   member data of a class `T` and `arg1` is not one of the types
    //!   described in the previous item;
    //!
    //! - `f(arg1, arg2, ..., argN)` in all other cases.
    //!
    //! \param f A target callable object.
    //!
    //! \param ...args The arguments to the callable object.
    //!
    //! \requires `INVOKE(std::forward<F>(f), std::forward<Args>(args)...)`
    //! shall be well-formed.
    //!
    //! \returns The result of invoking the callable.
    //!
    //! \throws Nothing unless the invoked callable throws an exception.
    //!
    //! \see \link meta::invoke \endlink,
    //!      \link invoke(F&&, expand_tuple_t, Args&&) \endlink,
    //!      \link result_of::invoke \endlink,
    //!      \link result_of::invoke_t \endlink,
    //!      \link functional::invoke \endlink
    template <typename F, typename ...Args>
    constexpr result_of::invoke_t<F, Args...>
    invoke(F&& f, Args&&... args)
    EGGS_TUPLEWARE_RETURN(
        detail::invoke(
            std::forward<F>(f), std::forward<Args>(args)...)
    )

    //! \brief Invokes a callable with arguments from a `tuple`
    //!
    //! \param f A target callable object.
    //!
    //! \param args The arguments to the callable object.
    //!
    //! \requires `INVOKE(std::forward<F>(f), std::get<Is>(std::forward<Args>(args)...))`
    //! shall be well-formed, where `Is` is a variadic pack of `std::size_t`
    //! values indexing the tuple `args`.
    //!
    //! \returns The result of invoking the callable.
    //!
    //! \throws Nothing unless the invoked callable throws an exception.
    //!
    //! \see \link meta::invoke \endlink,
    //!      \link invoke(F&&, Args&&...) \endlink,
    //!      \link result_of::invoke \endlink,
    //!      \link result_of::invoke_t \endlink,
    //!      \link functional::invoke \endlink
    template <typename F, typename Args>
    constexpr result_of::invoke_t<F, expand_tuple_t, Args>
    invoke(F&& f, expand_tuple_t, Args&& args)
    EGGS_TUPLEWARE_RETURN(
        detail::invoke(
            std::forward<F>(f)
          , expand_tuple_t{}, std::forward<Args>(args))
    )

    namespace functional
    {
        //! \brief Functional version of \ref invoke(F&&, Args&&...),
        //! \ref invoke(F&&, expand_tuple_t, Args&&)
        //!
        //! \see \link meta::invoke \endlink,
        //!      \link invoke(F&&, Args&&...) \endlink,
        //!      \link invoke(F&&, expand_tuple_t, Args&&) \endlink,
        //!      \link result_of::invoke \endlink,
        //!      \link result_of::invoke_t \endlink
        struct invoke
        {
            //! \copydoc invoke(F&&, Args&&...)
            //!
            //! \remarks This `operator()` shall not participate in overload
            //! resolution if the invoke expression is ill-formed.
            template <typename F, typename ...Args>
            constexpr result_of::invoke_t<F, Args...>
            operator()(F&& f, Args&&... args) const
            EGGS_TUPLEWARE_RETURN(
                detail::invoke(
                    std::forward<F>(f), std::forward<Args>(args)...)
            )

            //! \copydoc invoke(F&&, expand_tuple_t, Args&&)
            //!
            //! \remarks This `operator()` shall not participate in overload
            //! resolution if the invoke expression is ill-formed.
            template <typename F, typename Args>
            constexpr result_of::invoke_t<F, expand_tuple_t, Args>
            operator()(F&& f, expand_tuple_t, Args&& args) const
            EGGS_TUPLEWARE_RETURN(
                detail::invoke(
                    std::forward<F>(f)
                  , expand_tuple_t{}, std::forward<Args>(args))
            )
        };
    }

    ///////////////////////////////////////////////////////////////////////////
    //! \cond DETAIL
    template <typename F, typename ...Args>
    typename detail::enable_if_failure<
        result_of::invoke<F, Args...>
    >::type invoke(F&& f, Args&&... args)
    {
        detail::_explain_invoke(
            std::forward<F>(f), std::forward<Args>(args)...);
    }
    //! \endcond
}}

#endif /*EGGS_TUPLEWARE_INVOKE_HPP*/
