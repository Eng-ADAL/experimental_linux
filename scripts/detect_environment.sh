detect_environment() {
    if [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
        echo "wsl"
    elif systemd-detect-virt --quiet; then
        systemd-detect-virt
    else
        echo "physical"
    fi
}


detect_distro() {
    source /etc/os-release
    echo "$ID"
}

ENVIRONMENT="$(detect_environment)"
DISTRO="$(detect_distro)"


if [[ "$ENVIRONMENT" == "wsl" ]]; then
    install_wsl_clipboard
fi

if [[ "$ENVIRONMENT" == "vmware" ]]; then
    install_vmware_tools
fi

if [[ "$DISTRO" == "ubuntu" ]]; then
    apt install ...
fi
