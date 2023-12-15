#!/usr/bin/env bash
set -ex

# make the evaluation files available
git clone --depth=1 https://github.com/gallenmu/pos-artifacts /root/pos-artifacts
git -C pos-artifacts checkout 23db1626c0335ead64a51cbbb0cb845d93b30c77

# install dependencies
export DEBIAN_FRONTEND=noninteractive
apt-get update &&apt-get install --yes python3-pip libffi-dev zlib1g-dev libjpeg-dev
pip3 install -r /root/pos-artifacts/plot_scripts/requirements.txt

# plot measurement data to files
python3 /root/pos-artifacts/plot_scripts/plot_throughput.py '/root' 'results' \
    --label T \
    --name chameleon \
    --throughput-filename 'throughput_run*.log' \
    --throughput-strip 2 \
    --metric avg_mpps \
    --loop-filename '*.loop' \
    --loop-order pkt_sz \
    --loop-order pkt_rate \
    --additional-export svg

# define the content of each file
for file in 'figures/'*'.svg'; do
    pos_set_variable -g "${file}" "$(<"${file}")"
done
# define the list of files
pos_set_variable -g svg_files 'figures/'*'.svg'