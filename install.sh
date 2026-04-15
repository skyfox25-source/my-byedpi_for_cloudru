#!/bin/bash

# Настройки (уже под твой репозиторий)
REPO_URL="https://githubusercontent.com"
FILE_NAME="ciadpi-x86_64"
INSTALL_DIR="/usr/local/bin"

echo "--- Установка ByeDPI для Cloud.ru ---"

# 1. Скачивание файла
sudo wget -O $INSTALL_DIR/$FILE_NAME "$REPO_URL/$FILE_NAME"
sudo chmod +x $INSTALL_DIR/$FILE_NAME

# 2. Создание сервиса (-d 1 -m 1, как мы подобрали)
sudo bash -c "cat <<EOT > /etc/systemd/system/byedpi.service
[Unit]
Description=ByeDPI Service
After=network.target

[Service]
Type=simple
User=root
ExecStart=$INSTALL_DIR/$FILE_NAME -d 1 -m 1 -p 1080
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOT"

# 3. Запуск
sudo systemctl daemon-reload
sudo systemctl enable byedpi
sudo systemctl restart byedpi

echo "--- Готово! Проверь статус: sudo systemctl status byedpi ---"
