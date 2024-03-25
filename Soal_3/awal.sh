#!/bin/bash

# Fungsi untuk download dan ekstrak
firstcontact() {
    wget --no-check-certificate "https://drive.google.com/uc?export=download&id=1oGHdTf4_76_RacfmQIV4i7os4sGwa9vN" -O genshin.zip
    unzip genshin.zip
    unzip genshin_character.zip
}

# Fungsi untuk decrypt dan Memindah file
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


# Fungsi menampilkan pengemban senjata
weaponbearer() {
    sourcepath="genshin_character"
    weaponkind="Bow Claymore Catalyst Polearm Sword"
    for weapon in $weaponkind; do
        count=$(find "$sourcepath" -name "*$weapon*"*".jpg" | wc -l)
        echo "$weapon : $count"
    done
}

# Fungsi menghapus file
remove() {
    rm list_character.csv genshin.zip genshin_character.zip
}

# Fungsi utama
projectsherlock() {
    firstcontact
    decmove
    weaponbearer
    remove
}

# Call fungsi
projectsherlock
