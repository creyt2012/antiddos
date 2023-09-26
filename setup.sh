#!/bin/bash

echo "
  ____             __          _       _                
 / ___|    __ _   / _|   ___  | |     (_)  _ __     ___ 
 \___ \   / _\` | | |_   / _ \ | |     | | | '_ \   / _ \\
  ___) | | (_| | |  _| |  __/ | |___  | | | | | | |  __/
 |____/   \__,_| |_|    \___| |_____| |_| |_| |_|  \___|
"

qrcode() {
    echo "█████████████████████████████████████████"
    echo "█████████████████████████████████████████"
    echo "████ ▄▄▄▄▄ █▀ █▀▀██▀▄▀▀▄▀▄▀▄██ ▄▄▄▄▄ ████"
    echo "████ █   █ █▀ ▄ █▀▄▄▀▀ ▄█▄  ▀█ █   █ ████"
    echo "████ █▄▄▄█ █▀█ █▄█▄▀▀▄▀▄ ▀▀▄▄█ █▄▄▄█ ████"
    echo "████▄▄▄▄▄▄▄█▄█▄█ █▄▀ █ ▀▄▀ █▄█▄▄▄▄▄▄▄████"
    echo "████▄ ▄▄ █▄▄  ▄█▄▄▄▄▀▄▀▀▄██ ▄▄▀▄█▄▀ ▀████"
    echo "████▄ ▄▀▄ ▄▀▄ ▀ ▄█▀ ▀▄ █▀▀ ▀█▀▄██▄▀▄█████"
    echo "█████ ▀▄█ ▄ ▄▄▀▄▀▀█▄▀▄▄▀▄▀▄ ▄ ▀▄▄▄█▀▀████"
    echo "████ █▀▄▀ ▄▀▄▄▀█▀ ▄▄ █▄█▀▀▄▀▀█▄█▄█▀▄█████"
    echo "████ █ ▀  ▄▀▀ ██▄█▄▄▄▄▄▀▄▀▀▀▄▄▀█▄▀█ ▀████"
    echo "████ █ ▀▄ ▄██▀▀ ▄█▀ ▀███▄  ▀▄▀▄▄ ▄▀▄█████"
    echo "████▀▄▄█  ▄▀▄▀ ▄▀▀▀▄▀▄▀ ▄▀▄  ▄▀ ▄▀█ ▀████"
    echo "████ █ █ █▄▀ █▄█▀ ▄▄███▀▀▀▄█▀▄ ▀  ▀▄█████"
    echo "████▄███▄█▄▄▀▄ █▄█▄▄▄▄▀▀▄█▀▀ ▄▄▄  ▀█ ████"
    echo "████ ▄▄▄▄▄ █▄▀█ ▄█▀▄ █▀█▄ ▀  █▄█  ▀▄▀████"
    echo "████ █   █ █  █▄▀▀▀▄▄▄▀▀▀▀▀▀ ▄▄  ▀█  ████"
    echo "████ █▄▄▄█ █  ▀█▀ ▄▄▄▄ ▀█ ▀▀▄▀ ▀▀ ▀██████"
    echo "████▄▄▄▄▄▄▄█▄▄██▄█▄▄█▄██▄██▄▄█▄▄█▄█▄█████"
    echo "█████████████████████████████████████████"
    echo "█████████████████████████████████████████"

    echo
    echo "微信扫描上方二维码加入雷池项目讨论组"
}

    echo "Script Anti DDoS"
}

command_exists() {
	command -v "$1" 2>&1
}

space_left() {
    dir="$1"
    while [ ! -d "$dir" ]; do
        dir=`dirname "$dir"`;
    done
    echo `df -h "$dir" --output='avail' | tail -n 1`
}

start_docker() {
    systemctl start docker && systemctl enable docker
}

confirm() {
    echo -e -n "\033[34m[SafeLine] $* \033[1;36m(Y/n)\033[0m"
    read -n 1 -s opt

    [[ "$opt" == $'\n' ]] || echo

    case "$opt" in
        'y' | 'Y' ) return 0;;
        'n' | 'N' ) return 1;;
        *) confirm "$1";;
    esac
}

info() {
    echo -e "\033[37m[Mortar Cloud] $*\033[0m"
}

warning() {
    echo -e "\033[33m[Mortar Cloud] $*\033[0m"
}

abort() {
    qrcode
    echo -e "\033[31m[Mortar Cloud] $*\033[0m"
    exit 1
}

trap 'onexit' INT
onexit() {
    echo
    abort "Người dùng kết thúc cài đặt theo cách thủ công"
}

# CPU ssse3 Kiểm tra tập lệnh
support_ssse3=1
lscpu | grep ssse3 > /dev/null 2>&1
if [ $? -ne "0" ]; then
    echo "không tìm thấy thông tin trong lscpu"
    support_ssse3=0
fi

cat /proc/cpuinfo | grep ssse3 > /dev/null 2>&1
if [ $support_ssse3 -eq "0" -a $? -ne "0" ]; then
    abort "Thunderpool cần được chạy với sự hỗ trợ ssse3 tập lệnh CPU Trên máy ảo, vui lòng tự cấu hình và kích hoạt nó. CPU ssse3 Hỗ trợ tập lệnh"
fi

safeline_path='/data/safeline'

if [ -z "$BASH" ]; then
    abort "Vui lòng sử dụng bash Để thực thi tập lệnh này, vui lòng tham khảo tài liệu kỹ thuật chính thức mới nhất"
fi

if [ ! -t 0 ]; then
    abort "STDIN Đây không phải là thiết bị đầu vào tiêu chuẩn, vui lòng tham khảo tài liệu kỹ thuật chính thức mới nhất."
fi

if [ "$#" -ne "0" ]; then
    abort "Tập lệnh hiện tại không yêu cầu bất kỳ tham số nào, vui lòng tham khảo tài liệu kỹ thuật chính thức mới nhất"
fi

if [ "$EUID" -ne "0" ]; then
    abort "Vui lòng cài đặt với quyền root"
fi
info "Phương thức gọi tập lệnh được xác nhận là bình thường."

if [ -z `command_exists docker` ]; then
    warning "Thiếu môi trường Docker"
    if confirm "Bạn có cần cài đặt Docker tự động không?"; then
        curl -sSLk https://get.docker.com/ | bash
        if [ $? -ne "0" ]; then
            abort "Docker cài đặt thất bại"
        fi
        info "Docker Quá trình cài đặt đã hoàn tất"
    else
        abort "Hủy cài đặt"
    fi
fi
info "Phát hiện Docker : '`command -v docker`'"

start_docker
docker version > /dev/null 2>&1
if [ $? -ne "0" ]; then
    abort "Docker Dịch vụ hoạt động bất thường"
fi
info "Docker Hoạt động bình thường"

compose_command="docker compose"
if $compose_command version; then
    info "Khám phá Plugin Docker Compose"
else
    warning "Không tìm thấy Plugin soạn thảo Docker"
    compose_command="docker-compose"
    if [ -z `command_exists "docker-compose"` ]; then
        warning "không tìm thấy thành phần docker-compose"
        if confirm "Bạn có cần tự động cài đặt Docker Compose Plugin không?"; then
            curl -sSLk https://get.docker.com/ | bash
            if [ $? -ne "0" ]; then
                abort "Cài đặt Plugin Docker Compose không thành công"
            fi
            info "Quá trình cài đặt Plugin Docker Compose đã hoàn tất"
            compose_command="docker compose"
        else
            abort "Hủy cài đặt"
        fi
    else
        info "Khám phá thành phần docker-compose: '`command -v docker-compose`'"
    fi
fi

while true; do
    echo -e -n "\033[34m[SafeLine] Thư mục cài đặt (Để trống để '$safeline_path'): \033[0m"
    read input_path
    [[ -z "$input_path" ]] && input_path=$safeline_path

    if [[ ! $input_path == /* ]]; then
        warning "'$input_path' Không phải là con đường tuyệt đối về mặt pháp lý"
        continue
    fi

    if [ -f "$input_path" ] || [ -d "$input_path" ]; then
        warning "'$input_path' Đường dẫn đã tồn tại, vui lòng thay đổi nó."
        continue
    fi

    safeline_path=$input_path

    if confirm "Mục lục '$safeline_path' Dung lượng lưu trữ còn lại hiện tại là `space_left \"$safeline_path\"` ，Cần ít nhất là 5GB, bạn chắc chứ?"; then
        break
    fi
done

mkdir -p "$safeline_path"
if [ $? -ne "0" ]; then
    abort "Tạo thư mục cài đặt '$safeline_path' thất bại"
fi
info "Tạo thư mục cài đặt '$safeline_path' thành công"
cd "$safeline_path"

curl -sS "https://waf-ce.chaitin.cn/release/latest/compose.yaml" -o compose.yaml
if [ $? -ne "0" ]; then
    abort "Tải xuống tập lệnh soạn thảo.yaml không thành công"
fi
info "Tải xuống tập lệnh soạn thảo.yaml thành công"

touch ".env"
if [ $? -ne "0" ]; then
    abort "Tạo tập lệnh .env không thành công"
fi
info "Đã tạo tập lệnh .env thành công"

echo "SAFELINE_DIR=$safeline_path" >> .env
echo "IMAGE_TAG=latest" >> .env
echo "MGT_PORT=9443" >> .env
echo "POSTGRES_PASSWORD=$(LC_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c 32)" >> .env
echo "REDIS_PASSWORD=$(LC_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c 32)" >> .env
echo "SUBNET_PREFIX=172.22.222" >> .env

info "Quá trình tải xuống hình ảnh Docker sẽ sớm bắt đầu"

$compose_command up -d

if [ $? -ne "0" ]; then
    abort "Không khởi động được vùng chứa Docker"
fi

qrcode

warning "WAF Community Edition đã được cài đặt thành công. Vui lòng truy cập địa chỉ sau để truy cập bảng điều khiển."
warning "https://0.0.0.0:9443/"

