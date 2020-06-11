/******************************************************************************
 * api_header.cpp
 *
 * Copyright (c) Daniel Davidson
 *
 * Distributed under the Boost Software License
 * (http://www.boost.org/LICENSE_1_0.txt)
 *******************************************************************************/
/*! 
 * \file api_header.cpp
 *
 * \brief 
 * 
 */
#include <pantheios/pantheios.hpp>
#include <pantheios/inserters.hpp>
#include <pantheios/frontends/stock.h>
#include "fcs/examples/enums_static/api_header.hpp"
#include "fcs/patterns/api_initializer.hpp"
#include <cstring>
#include <stdexcept>
#include <iostream>

namespace fcs {
namespace examples {
namespace enums_static {
  // Class enumerations

  FCS_EXAMPLES_ENUMS_STATIC_API char const* to_c_str(API_first e) {
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
  FCS_EXAMPLES_ENUMS_STATIC_API void from_c_str(char const* txt, API_second &value) {
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

  FCS_EXAMPLES_ENUMS_STATIC_API char const* to_c_str(API_second e) {
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
  FCS_EXAMPLES_ENUMS_STATIC_API void dump_api_mask_first(std::ostream &out, int e) {
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
  FCS_EXAMPLES_ENUMS_STATIC_API void dump_api_mask_second(std::ostream &out, int e) {
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
  FCS_EXAMPLES_ENUMS_STATIC_API void from_c_str(char const* txt, API_with_assignments &value) {
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

  FCS_EXAMPLES_ENUMS_STATIC_API char const* to_c_str(API_with_assignments e) {
    switch(e) {
      case API_wa_42: return "API_wa_42";
      case API_wa_77: return "API_wa_77";
    }
    return "INVALID_API_WITH_ASSIGNMENTS";
  } 

  FCS_EXAMPLES_ENUMS_STATIC_API char const* to_c_str(API_shorten_long_name e) {
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
 
    
} // namespace fcs
} // namespace examples
} // namespace enums_static
#if defined(FCS_EXAMPLES_ENUMS_STATIC_API_EXPORTS)
extern  "C" const char PANTHEIOS_FE_PROCESS_IDENTITY[] = "api_header_so";
#endif

namespace {
void api_header_init() {
pantheios::log(PANTHEIOS_SEV_DEBUG, "Init api api_header");
}

void api_header_fini() {
pantheios::log(PANTHEIOS_SEV_DEBUG, "Fini api api_header");
}

fcs::patterns::Api_initializer<> initializer_s(&api_header_init, &api_header_fini);

}
