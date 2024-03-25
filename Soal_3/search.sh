#!/bin/bash

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
