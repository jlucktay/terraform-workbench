#!/bin/bash

sudo yum update -y
echo "alias lsl='ls -Al'" >> ~ec2-user/.bashrc
