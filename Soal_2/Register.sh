#!/bin/bash

echo "                                        "
echo "========================================"
echo "===WELCOME TO OUR SYSTEM REGISTRATION==="
echo "========================================"
echo "                                        "


#Mengekripsi password 
encrypt_password() {
    echo -n "$1" | base64
}

#Cek apakah file users.txt sudah terbuat, jika belum maka dibuat
touch users.txt

#Memasukkan informasi registrasi pengguna
read -p "Enter your email                   : " email
read -p "Enter your username                : " username
read -p "Enter a security question          : " security_question
read -p "Enter the answer to security answer: ": " security_answer

valid_password=false

#Loop untuk meminta pengguna memasukkan password yang memenuhi kebutuhan
while [ "$valid_password" = false ]; do
    read -sp "Enter you password: " password
    echo

 # Memeriksa apakah password memenuhi persyaratan keamanan
    if [ ${#password} -lt 8 ] || ! grep -q [[:lower:]] <<< "$password" || ! grep -q [[:upper:]] <<< "$password" || ! grep -q [[:digit:]] <<< "$password"; then
        echo "Password must be more than eight characters, have at least one capital letter, one lowercase letter, and one number"
    else
        valid_password=true
    fi
done


#Enkripsi password
encrypted_password=$(encrypt_password "$password")


# Menentukan apakah pengguna adalah admin berdasarkan email
if grep -qi "admin" <<< "$email"; then
    role="admin"
    echo "YEAYY!! Admin $username berhasil registrasi"
else
    role="user"
    echo "YEAYY!! User $username berhasil registrasi"
fi

# Menyimpan informasi registrasi ke users.txt
echo "$email:$username:$security_question:$security_answer:$encrypted_password:$role" >> users.txt

