#! /bin/bash

set -e

out_dir=openthread_mbedtls_out
nrfxlib_dir=../../../nrfxlib
mbedtls_dir=../../../mbedtls
nrf_security_build_dir=build/zephyr/modules/nrfxlib/nrf_security

lib_dir=$out_dir/lib
config_dir=$out_dir/config
include_dir=$out_dir/include
platform_dir=$out_dir/nrf_cc310_plat

rm -rvf $out_dir
mkdir -p $out_dir
mkdir -p $lib_dir
mkdir -p $config_dir
mkdir -p $platform_dir
mkdir -p $include_dir
mkdir -p $include_dir/mbedtls

# Insert glue layer config to nrf-config.h, replace #undef with #define and store it in $config_dir
grep -oE '^CONFIG_(GLUE|CC310|VANILLA)\w*MBEDTLS\w*_C' build/zephyr/.config |
  sort | uniq |
  (echo ''; sed 's/^/#define /'; echo '') |
  sed -E -e '/\/\* Target and application specific configurations \*\//r /dev/stdin' \
    $nrf_security_build_dir/include/nrf-config.h \
    > $config_dir/nrf-config.h

# Copy Vanilla only files
cp -v $nrf_security_build_dir/src/mbedtls/libmbedtls_base_vanilla.a $lib_dir
cp -v $nrf_security_build_dir/src/mbedtls/libmbedtls_tls_vanilla.a $lib_dir
cp -v $nrf_security_build_dir/src/mbedtls/libmbedtls_x509_vanilla.a $lib_dir

# Copy backends
cp -v $nrf_security_build_dir/src/mbedcrypto_glue/libmbedcrypto_cc310_backend.a $lib_dir
cp -v $nrf_security_build_dir/src/mbedcrypto_glue/libmbedcrypto_vanilla_backend.a $lib_dir

# Copy glue layer
cp -v $nrf_security_build_dir/src/mbedcrypto_glue/libmbedcrypto_glue.a $lib_dir
cp -v $nrf_security_build_dir/src/mbedcrypto_glue/libmbedcrypto_glue_cc310.a $lib_dir
cp -v $nrf_security_build_dir/src/mbedcrypto_glue/libmbedcrypto_glue_vanilla.a $lib_dir

# Copy platform
cp -v $nrfxlib_dir/crypto/nrf_cc310_platform/lib/cortex-m4/hard-float/no-interrupts/libnrf_cc310_platform_0.9.1.a $lib_dir
cp -va $nrfxlib_dir/crypto/nrf_cc310_platform/include $platform_dir/include
cp -va $nrfxlib_dir/crypto/nrf_cc310_platform/src $platform_dir/src

# Copy includes
cp -va $mbedtls_dir/include/mbedtls/* $include_dir/mbedtls
cp -va $nrf_security_build_dir/include/mbedtls_generated/* $include_dir/mbedtls
