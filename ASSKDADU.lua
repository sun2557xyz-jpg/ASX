Device Info:
    Platform: Android
    Arch: arm64
    Version: 69500
    Hash: e4fccad39e07e8c610a992e889e5d067

Basic Info:
    HWID: f6ce2f11fc57e8a8d6a635459ef7c9f8ef2dfbc54fd0547f2e436de1f5b408ec
    Pringle: false
    Game ID: 6765805766
    Place ID: 104715542330896
    Scripts Ran: false
    Last Action: EXECUTE SCRIPT

Crash Info:
    Signal: 11
    Signal Name: SIGSEGV
    Timestamp (Unix): 1761779367
    Timestamp (UTC+0): 2025-10-29 23:09:27.857

Stacktrace:
    #0: /data/data/com.roblox.client/shared_modules/2dee32e5922e9981bf6a2a8844b3c539/shared_cache:
        Location: 0x8c60c4

    #1: /apex/com.android.art/lib64/libsigchain.so:
        Location: 0x7394
        Symbol: _ZN3art11SignalChain7HandlerEiP7siginfoPv

    #2: [vdso]:
        Location: 0x89c
        Symbol: __kernel_rt_sigreturn

    #3: /vendor/lib64/egl/libGLES_mali.so:
        Location: 0x1b59e54

    #4: /vendor/lib64/egl/libGLES_mali.so:
        Location: 0x1d2ec14

    #5: /apex/com.android.runtime/lib64/bionic/libc.so:
        Location: 0xaa504
        Symbol: __cxa_finalize

    #6: /apex/com.android.runtime/lib64/bionic/libc.so:
        Location: 0xaf7ec
        Symbol: exit

    #7: /data/data/com.roblox.client/shared_modules/2dee32e5922e9981bf6a2a8844b3c539/shared_cache:
        Location: 0x8c6c64

    #8: [vdso]:
        Location: 0x89c
        Symbol: __kernel_rt_sigreturn

    #9: /apex/com.android.runtime/lib64/bionic/libc.so:
        Location: 0xb043c

    #10: /apex/com.android.runtime/lib64/bionic/libc.so:
        Location: 0xb0148
        Symbol: android_fdsan_close_with_tag

    #11: /apex/com.android.runtime/lib64/bionic/libc.so:
        Location: 0xb08e4
        Symbol: close

    #12: /data/app/~~fY_bTnH8bN6CeweXn4-RMA==/com.roblox.client-vX2teQAguRRQjy5KA7jZpQ==/lib/arm64/libpairipcore.so:
        Location: 0x48cb80

    #13: /data/app/~~fY_bTnH8bN6CeweXn4-RMA==/com.roblox.client-vX2teQAguRRQjy5KA7jZpQ==/lib/arm64/libpairipcore.so:
        Location: 0x48cd04

    #14: /data/app/~~fY_bTnH8bN6CeweXn4-RMA==/com.roblox.client-vX2teQAguRRQjy5KA7jZpQ==/lib/arm64/libpairipcore.so:
        Location: 0x497ba0

    #15: /data/app/~~fY_bTnH8bN6CeweXn4-RMA==/com.roblox.client-vX2teQAguRRQjy5KA7jZpQ==/lib/arm64/libpairipcore.so:
        Location: 0x4b30f8

    #16: /data/app/~~fY_bTnH8bN6CeweXn4-RMA==/com.roblox.client-vX2teQAguRRQjy5KA7jZpQ==/lib/arm64/libpairipcore.so:
        Location: 0x4b251c

    #17: /data/app/~~fY_bTnH8bN6CeweXn4-RMA==/com.roblox.client-vX2teQAguRRQjy5KA7jZpQ==/lib/arm64/libpairipcore.so:
        Location: 0x48232c

    #18: /data/app/~~fY_bTnH8bN6CeweXn4-RMA==/com.roblox.client-vX2teQAguRRQjy5KA7jZpQ==/lib/arm64/libpairipcore.so:
        Location: 0x2e9850

    #19: /data/app/~~fY_bTnH8bN6CeweXn4-RMA==/com.roblox.client-vX2teQAguRRQjy5KA7jZpQ==/lib/arm64/libpairipcore.so:
        Location: 0x2eb980

    #20: /data/app/~~fY_bTnH8bN6CeweXn4-RMA==/com.roblox.client-vX2teQAguRRQjy5KA7jZpQ==/lib/arm64/libpairipcore.so:
        Location: 0x2679d4

    #21: /data/app/~~fY_bTnH8bN6CeweXn4-RMA==/com.roblox.client-vX2teQAguRRQjy5KA7jZpQ==/lib/arm64/libpairipcore.so:
        Location: 0x265730

    #22: /data/app/~~fY_bTnH8bN6CeweXn4-RMA==/com.roblox.client-vX2teQAguRRQjy5KA7jZpQ==/lib/arm64/libpairipcore.so:
        Location: 0x251a44

    #23: /data/app/~~fY_bTnH8bN6CeweXn4-RMA==/com.roblox.client-vX2teQAguRRQjy5KA7jZpQ==/lib/arm64/libpairipcore.so:
        Location: 0x2518c8

    #24: /data/app/~~fY_bTnH8bN6CeweXn4-RMA==/com.roblox.client-vX2teQAguRRQjy5KA7jZpQ==/lib/arm64/libpairipcore.so:
        Location: 0x26ea60

    #25: /data/app/~~fY_bTnH8bN6CeweXn4-RMA==/com.roblox.client-vX2teQAguRRQjy5KA7jZpQ==/lib/arm64/libpairipcore.so:
        Location: 0x26ea14

    #26: /data/app/~~fY_bTnH8bN6CeweXn4-RMA==/com.roblox.client-vX2teQAguRRQjy5KA7jZpQ==/lib/arm64/libpairipcore.so:
        Location: 0x26e5d4

    #27: /apex/com.android.runtime/lib64/bionic/libc.so:
        Location: 0xbc380

    #28: /apex/com.android.runtime/lib64/bionic/libc.so:
        Location: 0xad604
