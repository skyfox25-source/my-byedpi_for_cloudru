#!/bin/bash

# --- Настройки ---
# Ссылка на сам файл (убрал лишнее из URL для корректной конкатенации)
REPO_URL="https://raw.githubusercontent.com/skyfox25-source/my-byedpi_for_cloudru/main/ciadpi-x86_64"
FILE_NAME="ciadpi-x86_64"
INSTALL_DIR="/usr/local/bin"

echo "--- Установка ByeDPI для Cloud.ru ---"

# 1. Скачивание файла
echo "Скачивание исполняемого файла..."
sudo wget -O "$INSTALL_DIR/$FILE_NAME" "$REPO_URL"
sudo chmod +x "$INSTALL_DIR/$FILE_NAME"

# 2. Создание сервиса
# Используем <<'EOF' (в кавычках), чтобы переменные внутри блока не подставлялись сейчас,
# а записывались в файл как текст.
echo "Создание системного сервиса..."
sudo bash -c "cat <<'EOF' > /etc/systemd/system/byedpi.service
[Unit]
Description=ByeDPI Service
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/ciadpi-x86_64 -d 1 -f 1 -e 1 -p 1080
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF"

# 3. Запуск
echo "Запуск и включение автозагрузки..."
sudo systemctl daemon-reload
sudo systemctl enable byedpi
sudo systemctl restart byedpi

echo "--- Готово! Проверь статус: sudo systemctl status byedpi ---"
