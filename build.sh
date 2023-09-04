#!/usr/bin/env bash


docker pull mcr.microsoft.com/cbl-mariner/base/core:2.0
docker build . -t parser
