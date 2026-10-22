#!/usr/bin/env bash
{
  echo "# Environment ($(date -u +%F))"
  echo "## Windows";  cmd.exe /c ver 2>/dev/null | tr -d '\r\0'
  echo "## WSL";      wsl.exe --version 2>/dev/null | tr -d '\r\0'
  echo "## Ubuntu";   lsb_release -ds
  echo "## Tools"
  arm-none-eabi-gcc --version | head -1
  arm-none-eabi-g++ --version | head -1
  arm-none-eabi-ld --version | head -1
  gdb-multiarch --version | head -1
  qemu-system-arm --version | head -1
  make --version | head -1; cmake --version | head -1; git --version
} > docs/ENV.md
