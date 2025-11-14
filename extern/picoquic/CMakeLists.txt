cmake_minimum_required(VERSION 3.13)

project(picoquic
    VERSION 1.1.40.0
    DESCRIPTION "picoquic library"
    LANGUAGES C CXX)

# THREADS
find_package(Threads REQUIRED)

# ==== DESACTIVAR TODO LO QUE ROMPE EN ANDROID ====
set(ENABLE_FUSION OFF CACHE BOOL "Disable Fusion on Android")
set(ENABLE_OPENSSL OFF CACHE BOOL "Disable OpenSSL on Android")
set(ENABLE_MBEDTLS OFF CACHE BOOL "Disable mbedTLS on Android")
set(ENABLE_MINICRYPTO ON CACHE BOOL "Enable minicrypto on Android")

# No intentar detectar AESNI (no existe en ARM/Android)
set(PICOQUIC_DISABLE_AESNI ON CACHE BOOL "Disable AESNI on Android")

# No autoscan de USDT / tracers
set(ENABLE_TRACER OFF)

# C flags para Android
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DANDROID -DPICOQUIC_NO_OPENSSL -DPICOQUIC_MINICRYPTO")

# Archivos fuente
set(PICOQUIC_SOURCES
    picoquic/bbr.c
    picoquic/bbr1.c
    picoquic/bytestream.c
    picoquic/cc_common.c
    picoquic/cidset.c
    picoquic/config.c
    picoquic/cubic.c
    picoquic/ech.c
    picoquic/error_names.c
    picoquic/fastcc.c
    picoquic/frames.c
    picoquic/intformat.c
    picoquic/logger.c
    picoquic/logwriter.c
    picoquic/loss_recovery.c
    picoquic/memory_log.c
    picoquic/newreno.c
    picoquic/pacing.c
    picoquic/packet.c
    picoquic/paths.c
    picoquic/performance_log.c
    picoquic/picohash.c
    picoquic/picoquic.c
    picoquic/picoquic_mbedtls.c
    picoquic/picoquic_ptls_minicrypto.c
)

# Biblioteca principal
add_library(picoquic-core STATIC ${PICOQUIC_SOURCES})

target_include_directories(picoquic-core PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}/picoquic)

target_link_libraries(picoquic-core PUBLIC Threads::Threads)