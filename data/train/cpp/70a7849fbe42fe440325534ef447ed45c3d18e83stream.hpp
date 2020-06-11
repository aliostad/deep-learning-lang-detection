/******************************************************************************
 *
 * stream.hpp
 *
 * @author Copyright (C) 2015 Kotone Itaya
 * @version 2.1.0
 * @created  2015/10/15 Kotone Itaya -- Created!
 * @modified 2015/11/02 Kotone Itaya -- Added operators.
 * @@
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
 *****************************************************************************/

#ifndef __SPIRA_STREAM_HPP__
#define __SPIRA_STREAM_HPP__

#include <functional>
#include <list>
#include <memory>
#include <cstdint>

namespace spira {
  enum class SAMPLED_BY {FIRST, SECOND, BOTH};

  template<typename T>
  class stream {
  public:
    template<typename U>
    friend class stream;

    stream();
    stream(const stream<T>& other);
    stream(stream<T>&& other) noexcept;
    stream<T>& operator =(const stream<T>& other);
    stream<T>& operator =(stream<T>&& other) noexcept;
    template<typename U>
    friend void swap(stream<U>& a, stream<U>& b);

    // Stream operations
    stream<T> unique();
    stream<T> mirror();
    stream<T> merge(stream<T> other);
    stream<T> filter(std::function<bool(T)> filter);
    stream<T> whilst(stream<bool> whilst);
    stream<T> scan(T seed, const std::function<T(T,T)> scan);
    template<typename U>
    stream<U> map(std::function<U(T)> map);
    template<typename U>
    stream<std::pair<T, U> > combine(stream<U> other, SAMPLED_BY flag);

    // For binding side-effects
    void bind(const std::function<void(T)> function);
  private:
    void glue(const std::function<void(T)> function);
    void hook(const std::function<void(T)> function);
  protected:
    // Protected for call from `source`
    void push(T value) const;
    void listcall(const std::list<std::function<void(T)> > list) const;
    void call() const;
  private:
    struct impl; std::shared_ptr<impl> pimpl;
  };

  // Operator overload abstraction
  template<typename T>
  stream<T> operate(stream<T> a, stream<T> b, std::function<T(T, T)> operation);
  template<typename T>
  stream<T> operate(stream<T> a, T b, std::function<T(T, T)> operation);
  template<typename T>
  stream<T> operate(T a, stream<T> b, std::function<T(T, T)> operation);

  // Comparison operator overloads
  template<typename T> stream<T> operator ==(stream<T> a, stream<T> b);
  template<typename T> stream<T> operator !=(stream<T> a, stream<T> b);
  template<typename T> stream<T> operator < (stream<T> a, stream<T> b);
  template<typename T> stream<T> operator > (stream<T> a, stream<T> b);
  template<typename T> stream<T> operator <=(stream<T> a, stream<T> b);
  template<typename T> stream<T> operator >=(stream<T> a, stream<T> b);

  template<typename T> stream<T> operator ==(stream<T> a, T b);
  template<typename T> stream<T> operator !=(stream<T> a, T b);
  template<typename T> stream<T> operator < (stream<T> a, T b);
  template<typename T> stream<T> operator > (stream<T> a, T b);
  template<typename T> stream<T> operator <=(stream<T> a, T b);
  template<typename T> stream<T> operator >=(stream<T> a, T b);

  template<typename T> stream<T> operator ==(T a, stream<T> b);
  template<typename T> stream<T> operator !=(T a, stream<T> b);
  template<typename T> stream<T> operator < (T a, stream<T> b);
  template<typename T> stream<T> operator > (T a, stream<T> b);
  template<typename T> stream<T> operator <=(T a, stream<T> b);
  template<typename T> stream<T> operator >=(T a, stream<T> b);

  // Arithmetic operator overloads
  template<typename T> stream<T> operator +(stream<T> a, stream<T> b);
  template<typename T> stream<T> operator -(stream<T> a, stream<T> b);
  template<typename T> stream<T> operator *(stream<T> a, stream<T> b);
  template<typename T> stream<T> operator /(stream<T> a, stream<T> b);
  template<typename T> stream<T> operator %(stream<T> a, stream<T> b);

  template<typename T> stream<T> operator +(stream<T> a, T b);
  template<typename T> stream<T> operator -(stream<T> a, T b);
  template<typename T> stream<T> operator *(stream<T> a, T b);
  template<typename T> stream<T> operator /(stream<T> a, T b);
  template<typename T> stream<T> operator %(stream<T> a, T b);

  template<typename T> stream<T> operator +(T a, stream<T> b);
  template<typename T> stream<T> operator -(T a, stream<T> b);
  template<typename T> stream<T> operator *(T a, stream<T> b);
  template<typename T> stream<T> operator /(T a, stream<T> b);
  template<typename T> stream<T> operator %(T a, stream<T> b);

  // Bitwise operator overloads
  template<typename T> stream<T> operator ~ (stream<T> a);

  template<typename T> stream<T> operator & (stream<T> a, stream<T> b);
  template<typename T> stream<T> operator ^ (stream<T> a, stream<T> b);
  template<typename T> stream<T> operator | (stream<T> a, stream<T> b);
  template<typename T> stream<T> operator <<(stream<T> a, stream<T> b);
  template<typename T> stream<T> operator >>(stream<T> a, stream<T> b);

  template<typename T> stream<T> operator & (stream<T> a, T b);
  template<typename T> stream<T> operator ^ (stream<T> a, T b);
  template<typename T> stream<T> operator | (stream<T> a, T b);
  template<typename T> stream<T> operator <<(stream<T> a, T b);
  template<typename T> stream<T> operator >>(stream<T> a, T b);

  template<typename T> stream<T> operator & (T a, stream<T> b);
  template<typename T> stream<T> operator ^ (T a, stream<T> b);
  template<typename T> stream<T> operator | (T a, stream<T> b);
  template<typename T> stream<T> operator <<(T a, stream<T> b);
  template<typename T> stream<T> operator >>(T a, stream<T> b);

  // Logical operator overloads
  template<typename T> stream<T> operator !(stream<T> a);

  template<typename T> stream<T> operator &&(stream<T> a, stream<T> b);
  template<typename T> stream<T> operator ||(stream<T> a, stream<T> b);

  template<typename T> stream<T> operator &&(stream<T> a, T b);
  template<typename T> stream<T> operator ||(stream<T> a, T b);

  template<typename T> stream<T> operator &&(T a, stream<T> b);
  template<typename T> stream<T> operator ||(T a, stream<T> b);
}

#include "stream_impl.hpp"

#endif
