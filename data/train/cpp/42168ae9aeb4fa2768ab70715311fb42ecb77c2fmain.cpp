/* This file is a part of ADK library.
 * Copyright (c) 2012-2015, Artyom Lebedev <artyom.lebedev@gmail.com>
 * All rights reserved.
 * See LICENSE file for copyright details.
 */

#include <adk.h>

#include "sample_lib.h"

SampleLib g_sampleLib;

SampleLib::SampleLib()
{
    g_message("SampleLib::SampleLib");
}

SampleLib::~SampleLib()
{
    g_message("SampleLib::~SampleLib");
}

Glib::RefPtr<Gtk::Builder>
SampleLib::Test()
{
    g_message("SampleLib::Test");
    return Gtk::Builder::create_from_string(ADK_GLADE_XML(main_window));
}
