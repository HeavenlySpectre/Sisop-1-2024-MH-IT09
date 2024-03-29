#!/bin/bash

#Inisialisasi
time=$(date +"%Y%m%d%H%M%S")
output_file="/home/azrael/log/metrics_agg_$time.log"

echo -n "minimum" > "$output_file"

# Fungsi untuk menghitung nilai minimum
calculate_min() {
    awk -F ',' -v col="$1" 'NR==1 {min=$col} NR>1 && $col<min {min=$col} NR==60 {exit} END {print min}' /home/azrael/log/*.log
}

# Fungsi untuk menghitung nilai maksimum
calculate_max() {
    awk -F ',' -v col="$1" 'NR==1 {max=$col} NR>1 && $col>max {max=$col} NR==60 {exit} END {print max}' /home/azrael/log/*.log
}

# Menambahkan nilai minimum untuk setiap kolom
for i in {1..7}
do
    echo -n ",$(calculate_min "$i")" >> "$output_file"
done

# Menambahkan nilai kolom ke-8
echo -n ",$(awk -F ',' 'NR==60 {print $8}' /home/azrael/log/*.log)" >> "$output_file"

# Menambahkan nilai minimum untuk kolom ke-9
echo -n ",$(calculate_min 9)" >> "$output_file"

# Menambahkan label "maximum"
echo -e -n "\nmaximum" >> "$output_file"

# Menambahkan nilai maksimum untuk setiap kolom
for i in {1..7}
do
    echo -n ",$(calculate_max "$i")" >> "$output_file"
done

# Menambahkan nilai kolom ke-8
echo -n ",$(awk -F ',' 'NR==60 {print $8}' /home/azrael/log/*.log)" >> "$output_file"

# Menambahkan nilai maksimum untuk kolom ke-9
echo -n ",$(calculate_max 9)" >> "$output_file"

# Menambahkan label "average"
echo -e -n "\naverage" >> "$output_file"

# Menghitung nilai rata-rata untuk setiap kolom
for i in {1..7}
do
    avg_val=$(awk -F ',' -v col="$i" '{sum += $col} END {if (NR > 0) print sum / NR}' /home/azrael/log/*.log)
    echo -n ",$avg_val" >> "$output_file"
done

# Menambahkan nilai kolom ke-8
echo -n ",$(awk -F ',' 'NR==60 {print $8}' /home/azrael/log/*.log)" >> "$output_file"

# Menghitung nilai rata-rata untuk kolom ke-9
echo -n ",$(awk -F ',' '{sum += $9} END {if (NR > 0) print sum / NR}' /home/azrael/log/*.log)" >> "$output_file"

# Mengatur izin file
chmod 600 /home/azrael/log/metrics_agg_$time.log

# Jadwalkan eksekusi script dengan cron job
# 0 * * * * /home/azrael/soal_4/aggregate_minutes_to_hourly_log.sh
