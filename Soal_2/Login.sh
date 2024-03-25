!/bin/bash

# Fungsi untuk mencatat log ke dalam file auth.log
log() {
    echo "[$(date '+%d/%m/%Y %H:%M:%S')] [$1] $2" >> auth.log
}

# Fungsi untuk menampilkan pesan sukses
success_message() {
    echo "Login berhasil."
}

# Fungsi untuk menampilkan pesan gagal
failure_message() {
    echo "Login gagal. Silakan coba lagi."
}

# Fungsi untuk menampilkan pertanyaan keamanan dan memeriksa jawabannya
security_question() {
    user_info=$(grep "^$email:" users.txt)
    security_question=$(cut -d ':' -f 3 <<< "$user_info")
    correct_answer=$(cut -d ':' -f 4 <<< "$user_info")

    read -p "$security_question: " user_answer

    if [ "$user_answer" == "$correct_answer" ]; then
        password=$(cut -d ':' -f 5 <<< "$user_info" | base64 -d)
        echo "Password Anda adalah: $password"
        log "FORGOT PASSWORD SUCCESS" "User with email $email retrieved forgotten password"
    else
        echo "Jawaban salah. Login gagal."
        log "FORGOT PASSWORD FAILED" "ERROR Failed attempt to retrieve forgotten password on user with email $email"
        exit 1
    fi
}

# Fungsi untuk menu admin
admin_menu() {
    echo "1. Tambahkan Pengguna Baru"
    echo "2. Edit Pengguna"
    echo "3. Hapus Pengguna"
    echo "4. Logout"
    read -p "Pilih menu admin: " admin_choice
 case "$admin_choice" in
        1)
            echo "Menambahkan pengguna..."
            # Tambahkan logika untuk menambah pengguna di sini
        ./register.sh
            ;;
        2)
            echo "Mengedit pengguna..."
            # Tambahkan logika untuk mengedit pengguna di sini
        ./edit.sh
            ;;
        3)
            echo "Menghapus pengguna..."
            # Tambahkan logika untuk menghapus pengguna di sini
        ./hapus.sh
            ;;
        4)
            echo "Logout..."
            exit 0
            ;;
        *)
            echo "Pilihan tidak ada di menu"
            ;;
    esac
}
echo "====WELCOME===="
echo "1. Login"
echo "2. Forgot Password"
read -p "Pilih menu: " choice

case "$choice" in
    1)
        # Meminta pengguna untuk memasukkan informasi login
        read -p "Masukkan email: " email

        # Mencari pengguna dalam file users.txt
        user_info=$(grep "^$email:" users.txt)

        if [ -z "$user_info" ]; then
            log "LOGIN FAILED" "ERROR Failed login attempt on user with email $email"
            failure_message
            exit 1
        fi

        # Meminta pengguna untuk memasukkan password
        read -sp "Masukkan password: " password
        echo

        # Memeriksa password
        stored_password=$(cut -d ':' -f 5 <<< "$user_info")
        if [[ "$(echo -n "$password" | base64)" != "$stored_password" ]]; then
            log "LOGIN FAILED" "ERROR Failed login attempt on user with email $email"
            failure_message
            exit 1
        fi

        # Memeriksa peran pengguna
        role=$(cut -d ':' -f 6 <<< "$user_info")

        # Jika pengguna adalah admin
        if [ "$role" == "admin" ]; then
            log "LOGIN SUCCESS" "Admin logged in successfully"
            echo "Login berhasil sebagai admin."
            # Panggil admin_menu di sini
            admin_menu
        else
log "LOGIN SUCCESS" "User with email $email logged in successfully"
            echo "Login berhasil sebagai user."
        fi

        success_message
        ;;
    2) 
        read -p "Masukkan email: " email
        security_question
        ;;
    *)
        echo "Pilihan tidak valid"
        ;;
esac
