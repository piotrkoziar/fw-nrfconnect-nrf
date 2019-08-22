/*
 * Copyright (c) 2018 Nordic Semiconductor ASA
 *
 * SPDX-License-Identifier: LicenseRef-BSD-5-Clause-Nordic
 */

#include <zephyr.h>
#include <misc/printk.h>

#include <dk_buttons_and_leds.h>

//		dk_set_led_on(DK_LED1);


#include <mbedtls/sha256.h>
#include <mbedtls/aes.h>
// #include <mbedtls/platform.h>
// #include <nrf_cc310_platform_mutex.h>
// #include <nrf_cc310_platform_abort.h>

static unsigned char hash[32];
// mbedtls_platform_context ctx;
mbedtls_aes_context a_ctx;
uint8_t key[32];

int main(void)
{
	int r;
	if (dk_leds_init() < 0) {
		printk("Cannot init LEDs!\n");
		return 1;
	}
	printk("START\n");
	// nrf_cc310_platform_abort_init();
	// nrf_cc310_platform_mutex_init();
	// r = mbedtls_platform_setup(&ctx);
	// if (r != 0) printk("Error %d at %d\n", r, __LINE__);
	r = mbedtls_sha256_ret("Hello World!", 12, hash, 0);
	if (r != 0) printk("Error %d at %d\n", r, __LINE__);
	for (r = 0; r < sizeof(hash); r++)
	{
		printk("%02X ", hash[r]);
	}
	mbedtls_aes_init(&a_ctx);
	r = mbedtls_aes_setkey_enc(&a_ctx, key, 256);
	if (r != 0) printk("Error %d at %d\n", r, __LINE__);
	printk("\nEND\n");
	return 0;
}
