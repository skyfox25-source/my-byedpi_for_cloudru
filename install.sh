#!/bin/bash

# Настройки (укажи свои переменные)
REPO_URL="https://github.com/skyfor2000/my_byedpi_for_cloudhu/releases/latest/download/" # адрес загрузки
FILE_NAME="my-byedpi-for-cloudhu.zip" # имя загружаемого архива
INSTALL_DIR="/opt/my-byedpi-for-cloudhu" # каталог установки программы
SYSTEMD_SERVICE_FILE="${INSTALL_DIR}/my-byedpi_for_cloudru.service" # файл службы systemd

# Сообщение начала процесса установки
echo "Установка ByeDPI для CloudRu..."

# Загрузка архива
wget "${REPO_URL}${FILE_NAME}" -P "$INSTALL_DIR"

# Распаковка архива
unzip -o "$INSTALL_DIR/$FILE_NAME" -d "$INSTALL_DIR"
rm -rf "$INSTALL_DIR/$FILE_NAME" # удаление скачанного архива после распаковки

# Создание файла службы systemd
cat << EOF > "$SYSTEMD_SERVICE_FILE"
[Unit]
Description=MyByedpiForCloudRu service
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 ${INSTALL_DIR}/main.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Перезагружаем демон systemd и активируем новую службу
sudo systemctl daemon-reload
sudo systemctl enable my-byedpi_for_cloudru.service
sudo systemctl start my-byedpi_for_cloudru.service
sudo systemctl restart my-byedpi_for_cloudru.service

# Завершение установки
echo "... Готово!"
echo "Проверка статуса: sudo systemctl status my-byedpi_for_cloudru.service."
