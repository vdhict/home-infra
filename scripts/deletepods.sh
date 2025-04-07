#!/bin/bash

echo "🔍 Searching for pods with ContainerStatusUnknown..."

kubectl get pods -A --no-headers | awk '$4 == "ContainerStatusUnknown" {print $1, $2}' | while read namespace pod; do
  echo "🚨 Deleting pod: $namespace/$pod (ContainerStatusUnknown)"
  kubectl delete pod "$pod" -n "$namespace"
done

echo "🔍 Searching for pods with Error..."

kubectl get pods -A --no-headers | awk '$4 == "Init:ContainerStatusUnknown" {print $1, $2}' | while read namespace pod; do
  echo "🚨 Deleting pod: $namespace/$pod (Init:ContainerStatusUnknown)"
  kubectl delete pod "$pod" -n "$namespace"
done

echo "🔍 Searching for pods with Error..."

kubectl get pods -A --no-headers | awk '$4 == "Error" {print $1, $2}' | while read namespace pod; do
  echo "🚨 Deleting pod: $namespace/$pod (Error)"
  kubectl delete pod "$pod" -n "$namespace"
done

kubectl get pods -A --no-headers | awk '$4 == "Completed" {print $1, $2}' | while read namespace pod; do
  echo "🚨 Deleting pod: $namespace/$pod (Completed)"
  kubectl delete pod "$pod" -n "$namespace"
done
