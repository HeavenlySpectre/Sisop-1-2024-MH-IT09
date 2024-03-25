wget --no-check-certificate 'https://drive.google.com/uc?export=download&id=1cC6MYBI3wRwDgqlFQE1OQUN83JAreId0' -O Sandbox.csv
ls //menampilkan daftar file di dalam direktori saat ini
cat Sandbox.csv //untuk memperlihatkan isi dari file Sandbox.csv
awk -F ',' '{total_sales[$1] += $3 * $4} END {for (buyer in total_sales) print buyer, total_sales[buyer]}' Sandbox.csv
awk -F ',' '{sales[$1] += $3 * $4} END {for (buyer in sales) print buyer, sales[buyer]}' Sandbox.csv | sort -k2nr
awk -F ',' '{sales[$1] += $3 * $4} END {for (buyer in sales) print buyer, sales[buyer]}' Sandbox.csv | sort -k2nr | head -n1 //Perintah ini menghitung total jumlah penjualan per pembeli, mengurutkannya secara menurun berdasarkan jumlah penjualan, dan menampilkan hasilnya.
awk -F ',' '{total_profit[$2] += $3 * $4 - $5} END {for (segment in total_profit) print segment, total_profit[segment]}' Sandbox.csv //Perintah ini menghitung total jumlah penjualan per pembeli, mengurutkannya secara menurun berdasarkan jumlah penjualan, memilih entri teratas pembeli dengan penjualan tertinggi, dan menampilkannya.
awk -F ',' '{profit[$2] += $3 * $4 - $5} END {for (segment in profit) print segment, profit[segment]}' Sandbox.csv | sort -k2n
awk -F ',' '{profit[$2] += $3 * $4 - $5} END {for (segment in profit) print segment, profit[segment]}' Sandbox.csv | sort -k2n | head -n1
awk -F ',' '{total_profit[$6] += $3 * $4 - $5} END {for (category in total_profit) print category, total_profit[category]}' Sandbox.csv
awk -F ',' '{profit[$6] += $3 * $4 - $5} END {for (category in profit) print category, profit[category]}' Sandbox.csv | sort -k2nr
awk -F ',' '{profit[$6] += $3 * $4 - $5} END {for (category in profit) print category, profit[category]}' Sandbox.csv | sort -k2nr | head -n3
grep 'adriaens' Sandbox.csv | awk -F ',' '{print $2, $3}'
awk '/Adriaens/ {print}' Sandbox.csv
grep 'Adriaens' Sandbox.csv | awk -F ',' '{print $2, $6, $17}'
