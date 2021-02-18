#!/bin/bash
i=10
sed "s/tagVersion/$i/g" pods.yml > node-app-pod.yml