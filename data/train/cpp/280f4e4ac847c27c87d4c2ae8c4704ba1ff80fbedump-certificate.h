/* -*- Mode:C++; c-file-style:"gnu"; indent-tabs-mode:nil -*- */
/*
 * Copyright (c) 2013, Regents of the University of California
 *                     Yingdi Yu
 *
 * BSD license, See the LICENSE file for more information
 *
 * Author: Yingdi Yu <yingdi@cs.ucla.edu>
 */

#ifndef NDN_TMP_DUMP_CERTIFICATE_H
#define NDN_TMP_DUMP_CERTIFICATE_H


namespace ndn
{

namespace security
{

  class DumpCertificate
  {
  public:
    DumpCertificate();
    
    ~DumpCertificate() {}

    void
    dump();
  };

}//security

}//ndn

#endif
