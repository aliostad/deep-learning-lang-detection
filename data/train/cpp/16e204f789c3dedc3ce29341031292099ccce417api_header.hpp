/******************************************************************************
 * api_header.hpp
 *
 * Copyright (c) Daniel Davidson
 *
 * Distributed under the Boost Software License
 * (http://www.boost.org/LICENSE_1_0.txt)
 *******************************************************************************/
/*! 
 * \file api_header.hpp
 *
 * \brief 
 * 
 */
#ifndef _FCS_EXAMPLES_ENUMS_API_HEADER_H_
#define _FCS_EXAMPLES_ENUMS_API_HEADER_H_

#include <iostream>
#include <cstring>
#include <stdexcept>

namespace fcs {
namespace examples {
namespace enums {

  // Library enumerations
  //! An enum specific to API with name API_first
  enum API_first {
    API_first_0,
    API_first_1,
    API_first_2,
    API_first_3,
    API_first_4,
    API_first_5
  };

  // Number of entries in API_first
  enum { API_FIRST_NUMBER_ENTRIES = 6 };

  inline char const* to_c_str(API_first e) {
    char const* values[] = {
      "API_first_0",
      "API_first_1",
      "API_first_2",
      "API_first_3",
      "API_first_4",
      "API_first_5"
    };
    size_t index(e);
    return ((index < API_FIRST_NUMBER_ENTRIES)? values[index] : "INVALID_API_FIRST");
  }

  inline std::ostream& operator<<(std::ostream &out, API_first e) {
    return out << to_c_str(e);
  }

  //! An enum specific to API with name API_second
  enum API_second {
    API_second_0,
    API_second_1,
    API_second_2,
    API_second_3,
    API_second_4,
    API_second_5,
    API_second_6
  };

  // Number of entries in API_second
  enum { API_SECOND_NUMBER_ENTRIES = 7 };

  inline void from_c_str(char const* txt, API_second &value) {
    if(0 == std::strcmp("API_second_0", txt)) {
      value = API_second_0;
      return;
    }
    if(0 == std::strcmp("API_second_1", txt)) {
      value = API_second_1;
      return;
    }
    if(0 == std::strcmp("API_second_2", txt)) {
      value = API_second_2;
      return;
    }
    if(0 == std::strcmp("API_second_3", txt)) {
      value = API_second_3;
      return;
    }
    if(0 == std::strcmp("API_second_4", txt)) {
      value = API_second_4;
      return;
    }
    if(0 == std::strcmp("API_second_5", txt)) {
      value = API_second_5;
      return;
    }
    if(0 == std::strcmp("API_second_6", txt)) {
      value = API_second_6;
      return;
    }
    std::string msg("No API_second value corresponding to: ");
    msg += txt;
    throw std::runtime_error(txt);
  }

  inline char const* to_c_str(API_second e) {
    char const* values[] = {
      "API_second_0",
      "API_second_1",
      "API_second_2",
      "API_second_3",
      "API_second_4",
      "API_second_5",
      "API_second_6"
    };
    size_t index(e);
    return ((index < API_SECOND_NUMBER_ENTRIES)? values[index] : "INVALID_API_SECOND");
  }

  inline std::ostream& operator<<(std::ostream &out, API_second e) {
    return out << to_c_str(e);
  }

  //! An enum specific to API with name API_mask_first
  enum API_mask_first {
    API_masked_first_0 = 1,
    API_masked_first_1 = 2,
    API_masked_first_2 = 4,
    API_masked_first_3 = 8,
    API_masked_first_4 = 16,
    API_masked_first_5 = 32,
    API_masked_first_6 = 64
  };

  enum { API_MASK_FIRST_NUMBER_ENTRIES = 7 };

  inline bool test_api_mask_first(int value, API_mask_first e) {
    return (e & value) == e;
  }

  inline void set_api_mask_first(int &value, API_mask_first e) {
    value |= e;
  }

  inline void clear_api_mask_first(int &value, API_mask_first e) {
    value &= ~e;
  }

  inline void dump_api_mask_first(std::ostream &out, int e) {
    out << '(';
    if(test_api_mask_first(e, API_masked_first_0)) {
      out << "API_masked_first_0,";
    }
    if(test_api_mask_first(e, API_masked_first_1)) {
      out << "API_masked_first_1,";
    }
    if(test_api_mask_first(e, API_masked_first_2)) {
      out << "API_masked_first_2,";
    }
    if(test_api_mask_first(e, API_masked_first_3)) {
      out << "API_masked_first_3,";
    }
    if(test_api_mask_first(e, API_masked_first_4)) {
      out << "API_masked_first_4,";
    }
    if(test_api_mask_first(e, API_masked_first_5)) {
      out << "API_masked_first_5,";
    }
    if(test_api_mask_first(e, API_masked_first_6)) {
      out << "API_masked_first_6,";
    }
    out << ')';
  }

  //! An enum specific to API with name API_mask_second
  enum API_mask_second {
    API_masked_second_0 = 1,
    API_masked_second_1 = 2,
    API_masked_second_2 = 4,
    API_masked_second_3 = 8,
    API_masked_second_4 = 16,
    API_masked_second_5 = 32,
    API_masked_second_6 = 64
  };

  enum { API_MASK_SECOND_NUMBER_ENTRIES = 7 };

  inline bool test_api_mask_second(int value, API_mask_second e) {
    return (e & value) == e;
  }

  inline void set_api_mask_second(int &value, API_mask_second e) {
    value |= e;
  }

  inline void clear_api_mask_second(int &value, API_mask_second e) {
    value &= ~e;
  }

  inline void dump_api_mask_second(std::ostream &out, int e) {
    out << '(';
    if(test_api_mask_second(e, API_masked_second_0)) {
      out << "API_masked_second_0,";
    }
    if(test_api_mask_second(e, API_masked_second_1)) {
      out << "API_masked_second_1,";
    }
    if(test_api_mask_second(e, API_masked_second_2)) {
      out << "API_masked_second_2,";
    }
    if(test_api_mask_second(e, API_masked_second_3)) {
      out << "API_masked_second_3,";
    }
    if(test_api_mask_second(e, API_masked_second_4)) {
      out << "API_masked_second_4,";
    }
    if(test_api_mask_second(e, API_masked_second_5)) {
      out << "API_masked_second_5,";
    }
    if(test_api_mask_second(e, API_masked_second_6)) {
      out << "API_masked_second_6,";
    }
    out << ')';
  }

  //! An enum specific to API with name API_with_assignments
  enum API_with_assignments {
    API_wa_42 = 42,
    API_wa_77 = 77
  };

  // Number of entries in API_with_assignments
  enum { API_WITH_ASSIGNMENTS_NUMBER_ENTRIES = 2 };

  inline void from_c_str(char const* txt, API_with_assignments &value) {
    if(0 == std::strcmp("API_wa_42", txt)) {
      value = API_wa_42;
      return;
    }
    if(0 == std::strcmp("API_wa_77", txt)) {
      value = API_wa_77;
      return;
    }
    std::string msg("No API_with_assignments value corresponding to: ");
    msg += txt;
    throw std::runtime_error(txt);
  }

  inline char const* to_c_str(API_with_assignments e) {
    switch(e) {
      case API_wa_42: return "API_wa_42";
      case API_wa_77: return "API_wa_77";
    }
    return "INVALID_API_WITH_ASSIGNMENTS";
  }

  inline std::ostream& operator<<(std::ostream &out, API_with_assignments e) {
    return out << to_c_str(e);
  }

  //! An enum specific to API with name API_shorten_long_name
  enum API_shorten_long_name {
    API_shorten_long_name_0,
    API_shorten_long_name_1,
    API_shorten_long_name_2,
    API_shorten_long_name_3,
    API_shorten_long_name_4,
    API_shorten_long_name_5
  };

  // Number of entries in API_shorten_long_name
  enum { API_SHORTEN_LONG_NAME_NUMBER_ENTRIES = 6 };

  inline char const* to_c_str(API_shorten_long_name e) {
    char const* values[] = {
      "API_sln_0",
      "API_sln_1",
      "API_sln_2",
      "API_sln_3",
      "API_sln_4",
      "API_sln_5"
    };
    size_t index(e);
    return ((index < API_SHORTEN_LONG_NAME_NUMBER_ENTRIES)? values[index] : "INVALID_API_SHORTEN_LONG_NAME");
  }

  inline std::ostream& operator<<(std::ostream &out, API_shorten_long_name e) {
    return out << to_c_str(e);
  }

  //! Dohh - clearly self explanatory
  enum { API_ANSWER_OF_UNIVERSE = 42 };

} // namespace enums
} // namespace examples
} // namespace fcs
#endif // _FCS_EXAMPLES_ENUMS_API_HEADER_H_
