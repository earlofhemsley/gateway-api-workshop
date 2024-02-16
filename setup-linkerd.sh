#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: 2022 Buoyant Inc.
# SPDX-License-Identifier: Apache-2.0
#
# Copyright 2022 Buoyant Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.  You may obtain
# a copy of the License at
#
#     http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#@SHOW

# Start by installing Linkerd and Linkerd Viz. We'll use the latest stable
# version.

if [ "$DEMO_MESH" != "linkerd" ]; then \
    echo "This script is for the Linkerd mesh only" >&2 ;\
    exit 1 ;\
fi

curl --proto '=https' --tlsv1.2 -sSfL https://run.linkerd.io/install | sh

linkerd check --pre
linkerd install --crds | kubectl apply -f -
linkerd install | kubectl apply -f -
linkerd viz install | kubectl apply -f -
linkerd check

# Once that's done, we can set up the namespace for Faces, annotated for
# Linkerd injection. Sadly, we can't do the same for Envoy Gateway, since it
# relies on a Job that will get hung up by the Linkerd sidecar -- KEP-753
# makes this better, but it's not fully supported in Kubernetes prior to 1.28,
# which is still a touch too new at the moment. Sigh.

kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: faces
  annotations:
    linkerd.io/inject: enabled
EOF
