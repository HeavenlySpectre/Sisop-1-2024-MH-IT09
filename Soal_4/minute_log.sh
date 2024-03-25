#!/bin/bash

# Direktori tujuan
directorypath="/home/azrael"

# Waktu saat ini
time=$(date +"%Y%m%d%H%M%S")

# Fungsi untuk mengumpulkan metrik
metrics(){
    rammet=$(free -m | sed -n '2{s/ \+/ /gp}' | cut -d ' ' -f 2-)
    swapmet=$(free -m | sed -n '3{s/ \+/ /gp}' | cut -d ' ' -f 2-)
    sizemet=$(du -sh "/home/azrael" | sed 's/\t.*//')
}

# Panggil fungsi metrik
metrics

# Tambahkan metrik ke dalam file log di direktori yang ditentukan
echo "$rammet","$swapmet","/home/azrael","$sizemet" | tr ' ' ',' >> "/home/azrael/log/metrics_${time}.log"

#*/1 * * * * /home/azrael/sisop/modul1/soal4/minute_log.sh
