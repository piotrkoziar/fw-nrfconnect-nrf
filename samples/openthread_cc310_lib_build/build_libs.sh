#! /bin/bash

set -e

out_dir=openthread_mbedtls_out
nrfxlib_dir=../../../nrfxlib
mbedtls_dir=../../../mbedtls
nrf_security_build_dir=build/zephyr/modules/nrfxlib/nrf_security
nrf_security_version=0.9.1

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

copy_libs()
{
  lib_version=$1
  short_wchar=$2
  if [ "$short_wchar" -eq "1" ]
  then
    name_sufix=_short_wchar
    platform_lib_path=/short-wchar
  fi
  # Copy Vanilla only files
  cp -v $nrf_security_build_dir/src/mbedtls/libmbedtls_base_vanilla.a $lib_dir/libmbedtls_base_vanilla$name_sufix.a
  cp -v $nrf_security_build_dir/src/mbedtls/libmbedtls_tls_vanilla.a $lib_dir/libmbedtls_tls_vanilla$name_sufix.a
  cp -v $nrf_security_build_dir/src/mbedtls/libmbedtls_x509_vanilla.a $lib_dir/libmbedtls_x509_vanilla$name_sufix.a

  # Copy backends
  cp -v $nrf_security_build_dir/src/mbedcrypto_glue/libmbedcrypto_cc310_backend.a $lib_dir/libmbedcrypto_cc310_backend$name_sufix.a
  cp -v $nrf_security_build_dir/src/mbedcrypto_glue/libmbedcrypto_vanilla_backend.a $lib_dir/libmbedcrypto_vanilla_backend$name_sufix.a

  # Copy glue layer
  cp -v $nrf_security_build_dir/src/mbedcrypto_glue/libmbedcrypto_glue.a $lib_dir/libmbedcrypto_glue$name_sufix.a
  cp -v $nrf_security_build_dir/src/mbedcrypto_glue/libmbedcrypto_glue_cc310.a $lib_dir/libmbedcrypto_glue_cc310$name_sufix.a
  cp -v $nrf_security_build_dir/src/mbedcrypto_glue/libmbedcrypto_glue_vanilla.a $lib_dir/libmbedcrypto_glue_vanilla$name_sufix.a

  # Copy platform
  cp -v $nrfxlib_dir/crypto/nrf_cc310_platform/lib/cortex-m4/hard-float$platform_lib_path/no-interrupts/libnrf_cc310_platform_0.9.1.a $lib_dir/libnrf_cc310_platform_$lib_version$name_sufix.a
}

rm -rf build
west build -b nrf52840_pca10056 .
cat ./build/zephyr/.config | grep WCHAR

# Insert glue layer config to nrf-config.h, replace #undef with #define and store it in $config_dir
grep -oE '^CONFIG_(GLUE|CC310|VANILLA)\w*MBEDTLS\w*_C' build/zephyr/.config |
  sort | uniq |
  (echo ''; sed 's/^/#define /'; echo '') |
  sed -E -e '/\/\* Target and application specific configurations \*\//r /dev/stdin' \
    $nrf_security_build_dir/include/nrf-config.h \
    > $config_dir/nrf-config.h

# Copy platform
cp -va $nrfxlib_dir/crypto/nrf_cc310_platform/include $platform_dir/include
cp -va $nrfxlib_dir/crypto/nrf_cc310_platform/src $platform_dir/src

# Copy includes
cp -va $mbedtls_dir/include/mbedtls/* $include_dir/mbedtls
cp -va $nrf_security_build_dir/include/mbedtls_generated/* $include_dir/mbedtls

copy_libs $nrf_security_version

for lib in $(find $lib_dir -name *.a);
do
  if readelf -aW $lib | c++filt | grep -e "wchar_t: [^4]"; then
    echo "Found lib ($lib) with sizeof(wchar_t) != 4"
    exit 1
  fi
done

rm -rf build
west build -b nrf52840_pca10056 . -- -DOVERLAY_CONFIG="overlay-short-wchar.conf"
cat ./build/zephyr/.config | grep WCHAR

copy_libs $nrf_security_version 1

for lib in $(find $lib_dir -name *_short_wchar.a);
do
  if readelf -aW $lib | c++filt | grep -e "wchar_t: [^2]"; then
    echo "Found lib ($lib) with sizeof(wchar_t) != 2"
    exit 1
  fi
done
