#
# Copyright (c) 2018 Nordic Semiconductor ASA
#
# SPDX-License-Identifier: LicenseRef-BSD-5-Clause-Nordic
#

if (CONFIG_BT)
  add_subdirectory(bluetooth)
endif()

add_subdirectory_ifdef(CONFIG_IS_SECURE_BOOTLOADER bootloader)
add_subdirectory_ifdef(CONFIG_SECURE_BOOT bootloader/image)
add_subdirectory_ifdef(CONFIG_SECURE_BOOT_CRYPTO_CLIENT bootloader/bl_crypto_client)

add_subdirectory(net)
add_subdirectory_ifdef(CONFIG_NRF_ESB		enhanced_shockburst)
add_subdirectory_ifdef(CONFIG_EVENT_MANAGER	event_manager)
add_subdirectory_ifdef(CONFIG_PROFILER		profiler)
add_subdirectory_ifdef(CONFIG_DFU_TARGET		dfu)
add_subdirectory_ifdef(CONFIG_IS_SPM		spm)
add_subdirectory_ifdef(CONFIG_TRUSTED_EXECUTION_NONSECURE nonsecure)
add_subdirectory_ifdef(CONFIG_MPSL mpsl)

if (CONFIG_NFC_T2T_NRFXLIB OR
    CONFIG_NFC_T4T_NRFXLIB OR
    CONFIG_NFC_T2T_PARSER  OR
    CONFIG_NFC_NDEF_PARSER OR
    CONFIG_NFC_T4T_ISODEP OR
    CONFIG_NFC_T4T_APDU OR
    CONFIG_NFC_T4T_CC_FILE OR
    CONFIG_NFC_T4T_HL_PROCEDURE)
        add_subdirectory(nfc)
endif()

add_subdirectory_ifdef(CONFIG_FW_INFO	fw_info)
add_subdirectory_ifdef(CONFIG_SHELL_BT_NUS	shell)

add_subdirectory(debug)
add_subdirectory(partition_manager)
