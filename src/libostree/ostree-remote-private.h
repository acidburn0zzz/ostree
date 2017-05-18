/* -*- mode: C; c-file-style: "gnu"; indent-tabs-mode: nil; -*-
 *
 * Copyright © 2011 Colin Walters <walters@verbum.org>
 * Copyright © 2015 Red Hat, Inc.
 * Copyright © 2017 Endless Mobile, Inc.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 *
 * Authors:
 *  - Colin Walters <walters@verbum.org>
 *  - Philip Withnall <withnall@endlessm.com>
 */

#pragma once

#include <gio/gio.h>
#include <glib.h>
#include <glib-object.h>

#include "libglnx.h"
#include "ostree-remote.h"
#include "ostree-types.h"

G_BEGIN_DECLS

struct OstreeRemote {
  volatile int ref_count;
  char *name;  /* (not nullable) */
  char *group;   /* group name in options (not nullable) */
  char *keyring; /* keyring name (NAME.trustedkeys.gpg) (not nullable) */
  GFile *file;   /* NULL if remote defined in repo/config */
  GKeyFile *options;
};

G_GNUC_INTERNAL
OstreeRemote *ostree_remote_new (void);

G_GNUC_INTERNAL
OstreeRemote *ostree_remote_new_from_keyfile (GKeyFile    *keyfile,
                                              const gchar *group);

#if (defined(OSTREE_COMPILATION) || GLIB_CHECK_VERSION(2, 44, 0)) && !defined(OSTREE_ENABLE_EXPERIMENTAL_API)
G_DEFINE_AUTOPTR_CLEANUP_FUNC (OstreeRemote, ostree_remote_unref)
#endif

G_END_DECLS