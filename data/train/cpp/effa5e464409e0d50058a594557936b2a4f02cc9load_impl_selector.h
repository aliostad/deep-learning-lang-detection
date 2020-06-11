/*
    This file is part of libbpk

    Copyright (C) 2012  Povilas Kanapickas

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see http://www.gnu.org/licenses/.
*/

#ifndef BPK_INTERNAL_LOAD_IMPL_SELECTOR_H
#define BPK_INTERNAL_LOAD_IMPL_SELECTOR_H

#include <bpk/fwd.h>
#include <bpk/load_context.h>

namespace Bpk {
namespace Internal {

// will be selected when a member load() exists (i.e. T::load(LoadContext&, Opts...) )
template<class T, class... Opts>
auto do_load_impl(LoadContext& ctx, T& t, int, int, int, Opts... opts) ->
    decltype(t.load(ctx, opts...), void())
{
    t.load(ctx, opts...);
}

// will be selected when a member load() without options exists (i.e. T::load(LoadContext&) )
template<class T, class... Opts>
auto do_load_impl(LoadContext& ctx, T& t, int, int, long, Opts... opts) ->
    decltype(t.load(ctx), void())
{
    t.load(ctx);
}

// will be selected when a global load() exists (i.e. load(LoadContext&, T&, Opts...) )
template<class T, class... Opts>
auto do_load_impl(LoadContext& ctx, T& t, int, long, long, Opts... opts) ->
    decltype(load(ctx, t, opts...), void())
{
    load(ctx, t, opts...);
}

// will be selected when a global load() without options exists (i.e. load(LoadContext&, T&) )
template<class T, class... Opts>
auto do_load_impl(LoadContext& ctx, T& t, long, long, long, Opts... opts) ->
    decltype(load(ctx, t), void())
{
    load(ctx, t);
}


template<class T, class... Opts>
auto do_load_impl2(LoadContext& ctx, T& t, int, Opts... opts) ->
    decltype(do_load_impl(ctx, t, 0, 0, 0, opts...), void())
{
    do_load_impl(ctx, t, 0, 0, 0, opts...);
}

template<class T, class... Opts>
void do_load_impl2(LoadContext& ctx, T& t, long, Opts... opts)
{
    (void) ctx; (void) t;
    static_assert(!std::is_same<T,T>::value,
                  "Type T does not provide a usable implementation of load()");
}


/** @internal
    Launches appropriate load() function or invokes static assertion if none is
    available for the given type and options. The first of the following
    options is selected:

     * member load(), if T::load(LoadContext&, Opts...) exists and is nonstatic
     * member load(), if T::load(LoadContext&) exists and is nonstatic
     * global load(), if load(LoadContext&, T&, Opts...) exists
     * global load(), if load(LoadContext&, T&) exists
     * static_assert is invoked

     If the load() does not accept options, they are ignored.
*/
template<class T, class... Opts>
void do_load(LoadContext& ctx, T& t, Opts... opts)
{
    do_load_impl2(ctx, t, 0, opts...);
}

} // namespace Internal
} // namespace Bpk

#endif
