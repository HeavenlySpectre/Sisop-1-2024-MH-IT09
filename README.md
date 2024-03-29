# Sisop-1-2024-MH-IT09

| Nama          | NRP          |
| ------------- | ------------ |
| Kevin Anugerah Faza | 5027231027 |
| Muhammad Hildan Adiwena | 5027231077 |
| Nayyara Ashila | 5027231083 |


## Soal 3
### - 3a)
#### awal.sh
Untuk menjawab soal pada poin 3a, berikut ini adalah code yang kami gunakan.
```
firstcontact() {
    wget --no-check-certificate "https://drive.google.com/uc?export=download&id=1oGHdTf4_76_RacfmQIV4i7os4sGwa9vN" -O genshin.zip
    unzip genshin.zip
    unzip genshin_character.zip
}
```
Fungsi `firstcontact` diatas digunakan untuk melakukan download dan ekstrak dari link yang telah disediakan. `wget --no-check-certificate "https://drive.google.com/uc?export=download&id=1oGHdTf4_76_RacfmQIV4i7os4sGwa9vN" -O genshin.zip`
digunakan untuk melakukan download dari link yang disediakan dan menyimpannya dalam file zip bernama genshin. Sedangkan `unzip genshin.zip` dan `unzip genshin_character.zip` digunakan untuk melakukan ekstraksi pada file yang telah didownload sebelumnya.
```
decmove() {
    sourcepath="genshin_character"
    csv_source="list_character.csv"
    
    for file in "$sourcepath"/*; do
        if [ -f "$file" ]; then
            raw_name=$(basename -- "$file")
            decrypt=$(echo -n "$raw_name" | xxd -r -p)
            extension="${file##*.}"
            mv "$file" "$sourcepath/$decrypt.${extension}"
        fi
    done
    # Baca data csv
    IFS=$'\n' read -d '' -a csvname < <(tail -n +2 "$csv_source")

    for row in "${csvname[@]}"; do
        name=$(echo "$row" | awk -F, '{print $1}')
        region=$(echo "$row" | awk -F, '{print $2}')
        element=$(echo "$row" | awk -F, '{print $3}')
        weapons=$(echo "$row" | awk -F, '{print $4}')
        
        # Mencocokkan data decrypt dan csv
        file=$(find "$sourcepath" -type f -name "${name}.jpg")

        if [ -n "$file" ]; then
            # Ubah name
            new_name="${region} - ${name} - ${element} - ${weapons}.jpg"
            cleaned_name=$(echo "${new_name}" | tr -d '\r')
            mv "$file" "$sourcepath/$cleaned_name"

            # Buat folder region (double check)
            regdir="${sourcepath}/${region}"
            if [ ! -d "$regdir" ]; then
                mkdir -p "$regdir"
            fi

            # Pindah file
            mv "$sourcepath/$cleaned_name" "$regdir/${cleaned_name}"
        fi
    done
}
```
Pada fungsi `decmove` diatas saya gunakan untuk menjawab bagian selanjutnya dari soal. Awalnya saya membuat variabel `sourcepath` dan `csv_source` yang merujuk pada folder genshin_character dan file list_character.csv. Kemudian saya menggunakan `for`  untuk iterasi setiap file dalam folder sourcepath. `if [ -f "$file" ]; then` digunakan untuk memeriksa apakah file yang sedang diiterasi adalah file/direktori. `raw_name=$(basename -- "$file")` digunakan untuk mengambil nama file tanpa mengikutkan ekstensinya. Selanjutnya saya melakukan decrypt dari hex menggunakan `decrypt=$(echo -n "$raw_name" | xxd -r -p)`. Saya gunakan `extension="${file##*.}"` untuk mengambil ekstensinya saja.  `mv "$file" "$sourcepath/$decrypt.${extension}"` digunakan untuk memindah file ke direktori sourcepath dengan nama yangtelah didecrypt dengan ekstensi yang telah diambil.

Berikutnya digunakan `IFS=$'\n' read -d '' -a csvname < <(tail -n +2 "$csv_source")` untuk membaca data dari file csv ke dalam `csvfile`. Pada loop berikutnya saya gunakan untuk mengiterasi dalam array csvname dan melakukan pengambilan `name,region,element, dan weapons` menggunakan`awk`. `file=$(find "$sourcepath" -type f -name "${name}.jpg")` digunakan untuk mencari file dan langkah berikutnya akan mengubah nama file, membuat region folder jika belum ada dan memindahkan file ke folder region tersebut.

### - 3b)
#### awal.sh
Untuk menjawab soal pada poin ini saya membuat fungsi tambahan yakni `weaponbearer` yang nantinya akan memberikan output berupa jumlah senjata yang dibawa oleh setiap karakter dan juga `remove` untuk membersihkan file yang tidak digunakan.
```
weaponbearer() {
    sourcepath="genshin_character"
    weaponkind="Bow Claymore Catalyst Polearm Sword"
    for weapon in $weaponkind; do
        count=$(find "$sourcepath" -name "*$weapon*"*".jpg" | wc -l)
        echo "$weapon : $count"
    done
}
remove() {
    rm list_character.csv genshin.zip genshin_character.zip
}
```
Pembuatan fungsi yang berisi fungsi-fungsi yang telah dibuat tadi untuk kemudian dijalankan ketika program dieksekusi.
```
# Fungsi utama
projectsherlock() {
    firstcontact
    decmove
    weaponbearer
    remove
}

# Call fungsi
projectsherlock
```
### - 3c,d,e)
#### search.sh
Pada 3 poin ini dapat dilakukan dengan membuat file search.sh yang digunakan untuk melakukan ekstraksi steghide yang terenkripsi. Namun perlu diketahui lebih lanjut bahwa ketika saya menggunakan enkripsi hex seperti yang diminta soal maka hasil yang diinginkan maka program tidak berhasil. Kemudian setelah melakukan analisa lebih lanjut, decrypt data dapat dilakukan dengan penggunaan base64 dan bukan hex. 
```
finalblow() {
    regions=("Mondstat" "Liyue" "Sumeru" "Fontaine" "Inazuma")
    touch image.log
    logfile="image.log"
}

sherlock() {
    local region="$1"
    for pict in "genshin_character/$region"/*jpg; do
        if [ -f "$pict" ]; then
            img_rn=$(basename "$pict")
            steghide extract -sf "$pict" -p "" -xf "${img_rn%.jpg}.txt"
            decrypted=$(cat "${img_rn%.jpg}.txt" | base64 --decode)
            curtime=$(date '+%d/%m/%y %H:%M:%S')

            if [[ "$decrypted" == *http* ]]; then
                wget --no-check-certificate "$decrypted"
                echo "[$curtime] [FOUND] $pict" >> "$logfile"
                exit 0
            else
                echo "[$curtime] [NOT FOUND] $pict" >> "$logfile"
                rm "${img_rn%.jpg}.txt"
            fi
        fi
    done
}

finalblow

for region in "${regions[@]}"; do
    sherlock "$region"
done
```
Pada code diatas saya menggunakan cara yang mirip yaitu menggunakan `for` loop untuk melakukan iterasi pada file dalam folder region untuk kemudian dilakukan decrypt dan proses lebih lanjut.

## Soal 4
Pada soal ini kita diminta untuk membuat monitoring resources dari suatu directory. Menggunakan command `free -m` untuk memeriksa ram dan `du -sh <target_path>` untuk memeriksa disk. Path directory yang akan dimonitor adalah `/home/{user}`

### - 4a)
#### minute_log.sh
Pada soal ini kita diminta untuk memasukkan semua metrics yang diperiksa ke dalam suatu file log dengan format `metrics_{YmdHms}.log`. Berikut ini adalah code yang digunakan untuk menyelesaikannya
```
directorypath="/home/azrael"
time=$(date +"%Y%m%d%H%M%S")

metrics(){
    rammet=$(free -m | sed -n '2{s/ \+/ /gp}' | cut -d ' ' -f 2-)
    swapmet=$(free -m | sed -n '3{s/ \+/ /gp}' | cut -d ' ' -f 2-)
    sizemet=$(du -sh "/home/azrael" | sed 's/\t.*//')
}

metrics

echo "$rammet","$swapmet","/home/azrael","$sizemet" | tr ' ' ',' >> "/home/azrael/log/metrics_${time}.log"
```
Code diawali dengan inisiasi `directorypath` dan juga `time` sesuai dengan yang diminta oleh soal. Kemudian fungsi `metrics` digunakan untuk mengumpulkan dan memilah data untuk nantinya akan ditampilkan dan disimpan ke dalam file bernama `metrics_${time}.log`. Fungsi metrics dipanggil dan nantinya akan disimpan sesuai pada direktori `/home/{user}/log`.
### - 4b)
#### crontab
Untuk menjawab soal ini saya menggunakan `crontab` agar script diatas dapat berjalan setiap menit.
```
*/1 * * * * /home/azrael/sisop/modul1/soal4/minute_log.sh
```
### - 4c)
#### aggregate_minutes_to_hourly_log.sh
Pada soal ini kami diminta untuk membuat sebuah script agregasi file log ke satuan jam dimana nantinya script ini akan memiliki info dari file log yang tergenerate setiap menitnya. Pada script ini juga harus terdapat nilai minimum, maximum, dan rata-rata tiap metrics.
Berikut ini adalah code yang telah kami buat
```
time=$(date +"%Y%m%d%H%M%S")
output_file="/home/azrael/log/metrics_agg_$time.log"

# Inisialisasi file log
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
```
Agar code dapat dijalankan setiap jamnya maka menambahkan konfigurasi berikut pada `crontab`
```
0 * * * * /home/azrael/soal_4/aggregate_minutes_to_hourly_log.sh
```
### -4d)
#### aggregate_minutes_to_hourly_log.sh
Agar izin hanya bisa dibaca oleh user pemilik file menggunakan command berikut
```
chmod 600 /home/azrael/log/metrics_agg_$time.log
```
