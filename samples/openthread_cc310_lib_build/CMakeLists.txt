#
# Copyright (c) 2018 Nordic Semiconductor
#
# SPDX-License-Identifier: LicenseRef-BSD-5-Clause-Nordic
#
cmake_minimum_required(VERSION 3.8.2)

include($ENV{ZEPHYR_BASE}/cmake/app/boilerplate.cmake NO_POLICY_SCOPE)
project(NONE)


#
# Configuration to build zephyr with wchar_t size of 2
#
if (CONFIG_SHORT_WCHAR_T)
  zephyr_compile_options(-fshort-wchar)
  #zephyr_ld_options(-Wl,--no-wchar-size-warning)
endif()

FILE(GLOB app_sources src/*.c)
# NORDIC SDK APP START
target_sources(app  PRIVATE ${app_sources})
# NORDIC SDK APP END
