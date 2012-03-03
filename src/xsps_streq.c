/* Copyright (c) 2012 davehome <davehome@redthumb.info.tm>.
 * Distributed under a modified BSD-style license.
 * See the COPYING file in the toplevel directory for license details. */

#include <string.h>

#include "xsps_streq.h"

bool xsps_streq(const char* s1, const char* s2) {
	return ((strcmp(s1, s2)) == 0);
}