#!/bin/bash

# 定义目标节点名称
TARGET_NODE_NAME="aio"

echo "正在查找绑定到节点 '$TARGET_NODE_NAME' 上的 Deployments..."
echo "命名空间           名称"
echo "------------------ --------------------"
# 获取所有命名空间中的 Deployments，使用 jq 进行筛选和格式化输出
kubectl get deployments --all-namespaces -o json | \
  jq -r --arg nodeName "$TARGET_NODE_NAME" '.items[] | select(.spec.template.spec.nodeName == $nodeName) | "\(.metadata.namespace)\t\t\(.metadata.name)"'

echo ""
echo "正在查找绑定到节点 '$TARGET_NODE_NAME' 上的 DaemonSets..."
echo "命名空间           名称"
echo "------------------ --------------------"
# 获取所有命名空间中的 DaemonSets，使用 jq 进行筛选和格式化输出
# 注意：DaemonSet 通常通过 nodeSelector 或 affinity 控制节点，直接使用 nodeName 的情况较少，但按要求检查
kubectl get daemonsets --all-namespaces -o json | \
  jq -r --arg nodeName "$TARGET_NODE_NAME" '.items[] | select(.spec.template.spec.nodeName == $nodeName) | "\(.metadata.namespace)\t\t\(.metadata.name)"'

echo ""
echo "正在查找绑定到节点 '$TARGET_NODE_NAME' 上的 CronJobs..."
echo "命名空间           名称"
echo "------------------ --------------------"
# 获取所有命名空间中的 CronJobs，使用 jq 进行筛选和格式化输出
kubectl get cronjobs --all-namespaces -o json | \
  jq -r --arg nodeName "$TARGET_NODE_NAME" '.items[] | select(.spec.jobTemplate.spec.template.spec.nodeName == $nodeName) | "\(.metadata.namespace)\t\t\(.metadata.name)"'

echo ""
echo "搜索完成。"
