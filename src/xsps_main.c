/* Copyright (c) 2012 davehome <davehome@redthumb.info.tm>.
 * Distributed under a modified BSD-style license.
 * See the COPYING file in the toplevel directory for license details. */

#include <stdlib.h>
#include <string.h>

#include "xsps.h"

int main(int argc, char** argv) {
	xsps_handle_t* xhp = xsps_handle_new();
	xsps_arg_parse(xhp, argc, argv);

	xsps_log_info(xhp, "%s -- %s!!!", "test", "hello");
	xsps_log_warn(xhp, "%c %s %x %d", '!', "hi", (unsigned int)&main, 50);

	xsps_handle_free(xhp);
	return 0;
}
