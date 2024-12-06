# Configuring your service mesh with Gateway API

This file validates instlalation of Istio for the Gateway API service mesh
workshop at KubeCon NA 2024 in Salt Lake City, Utah, USA.

<!--
SPDX-FileCopyrightText: 2022-2024 Buoyant Inc.
SPDX-License-Identifier: Apache-2.0

Things in Markdown comments are safe to ignore when reading this later. When
executing this with [demosh], things after the horizontal rule below (which
is just before a commented `@SHOW` directive) will get displayed.
-->

```bash
if [ "$DEMO_MESH" != "istio" ]; then \
  echo "This script is for the Istio mesh only" >&2 ;\
  exit 1 ;\
fi
```

<!-- @SHOW -->

Istio is a prerequisite for this demo. Let's validate the installation.

```bash
#@SHOW

which istioctl

istioctl version

istioctl x precheck
```

We'll use the minimal profile to skip installing the default ingress gateway so
we can create our own gateway.

```bash
istioctl install --set profile=minimal -y
```

And that's Istio ready to go!
