#! /bin/bash

set -e

out_dir=openthread_mbedtls_out
openthread_dir=/home/kasr/repos/openthread

west build -b nrf52840_pca10056 . || echo ''

./extract_libs.sh

rm -rvf $openthread_dir/third_party/NordicSemiconductor/libraries/nrf_security/config
rm -rvf $openthread_dir/third_party/NordicSemiconductor/libraries/nrf_security/include/mbedtls
rm -rvf $openthread_dir/third_party/NordicSemiconductor/libraries/nrf_security/lib
rm -rvf $openthread_dir/third_party/NordicSemiconductor/libraries/nrf_security/nrf_cc310_plat
cp -va $out_dir/* $openthread_dir/third_party/NordicSemiconductor/libraries/nrf_security/