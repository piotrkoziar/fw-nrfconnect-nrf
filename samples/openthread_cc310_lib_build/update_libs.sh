#! /bin/bash

set -e

out_dir=openthread_mbedtls_out
openthread_dir=$1

rm -rvf $openthread_dir/third_party/NordicSemiconductor/libraries/nrf_security/config
rm -rvf $openthread_dir/third_party/NordicSemiconductor/libraries/nrf_security/include/mbedtls
rm -rvf $openthread_dir/third_party/NordicSemiconductor/libraries/nrf_security/lib
rm -rvf $openthread_dir/third_party/NordicSemiconductor/libraries/nrf_security/nrf_cc310_plat
cp -va $out_dir/* $openthread_dir/third_party/NordicSemiconductor/libraries/nrf_security/