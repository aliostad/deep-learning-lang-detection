#include "SidApi.hpp"
#include "SidField.hpp"

namespace Sid {

  ApiRegistration* ApiRegistration::M_api_factory = 0;

  Api::Api(ModuleAPI* api, uint num_modules, Field* descriptors)
  : m_api(api),
    m_last_prop(0),
    m_num_modules(num_modules),
    m_descriptors(descriptors)
  {
  }

  Field* Api::get_property_desc(uint modid, uint propid, uint from_event)
  { 
    int evok = 0;
    Field* f = m_modprop2field.contains(modid, propid, evok);
    if (from_event && !evok)
      f = 0;
    return f;
  } 

  Field* Api::__get_property_desc(uint modid, uint propid) const
  { 
    if (modid <= m_num_modules) {
      for (uint b=0, e=m_api[modid].num_properties; b < e; ) {
        uint p = (b + e) / 2;
        uint key = m_api[modid].properties[p]->m_regular.m_tag;
        if (key == propid)
          return m_api[modid].properties[p];
        if (key < propid) 
          b = p+1;
        else 
          e = p;
      }
    }
    return 0;
  } 

  Api* Api::clone(const char* filter) const {
    Api* api = new Api(m_api, m_num_modules, m_descriptors);
    const char* begin = 0;
    if (filter && (begin = strstr(filter, "SkypeKit/SubscribedProperties=")) != 0) {
      // parse the filter
      uint modid, propid;
      for (const char* i=begin+strlen("SkypeKit/SubscribedProperties"); 
           i && sscanf(++i,"%u:%u",&modid,&propid) == 2; 
           i = strchr(i, ',')) {
        Field* f = __get_property_desc(modid,propid);
        if (f) { 
          api->m_modprop2field.add(modid,propid,f,1);
        }
      }
      int foo;
      for (uint m = 0; m <= m_num_modules; m++) {
        for (uint p=0, e=m_api[m].num_properties; p != e; p++) {
           uint propid = m_api[m].properties[p]->m_regular.m_tag;
           if (!api->m_modprop2field.contains(m,propid,foo)) {
             api->m_modprop2field.add(m,propid,m_api[m].properties[p],0);
           }
        }
      }
    } else {
      for (uint m = 0; m <= m_num_modules; m++) {
        for (uint p=0, e=m_api[m].num_properties; p != e; p++) {
            api->m_modprop2field.add(m,m_api[m].properties[p]->m_regular.m_tag,m_api[m].properties[p],1);
        }
      }
    }
    return api;
  }

  Api* ApiRegistration::find(const String& api, const char* filter)
  { if (M_api_factory) return M_api_factory->find_api(api, filter);
    return 0;
  }

  ApiRegistration::ApiRegistration(const String& name, ModuleAPI* api, uint num_modules, Field* descriptors)
  : m_next(M_api_factory),
    m_api(api, num_modules, descriptors),
    m_name(name)
  { M_api_factory = this; }

  Api* ApiRegistration::find_api(const String& api, const char* filter) 
  { if (api == m_name) return m_api.clone(filter);
    if (m_next) return m_next->find_api(api, filter);
    return 0;
  }

}

