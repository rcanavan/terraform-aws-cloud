#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

resource "helm_release" "calico" {
  count           = var.enable_calico ? 1 : 0
  atomic          = true
  chart           = var.calico_helm_chart_name
  cleanup_on_fail = true
  name            = "tigera-operator"
  namespace       = "kube-system"
  repository      = var.calico_helm_chart_repository
  timeout         = 300
  version         = var.calico_helm_chart_version

  set {
    name  = "installation.kubernetesProvider"
    value = "EKS"
    type  = "string"
  }

  dynamic "set" {
    for_each = var.calico_settings
    content {
      name  = set.key
      value = set.value
    }
  }
}