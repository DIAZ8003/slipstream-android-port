cmake_minimum_required(VERSION 3.13)

project(picoquic
    VERSION 1.1.40.0
    DESCRIPTION "picoquic library"
    LANGUAGES C CXX)

# -------------------------------------------
# CONFIGURACIÓN ANDROID (SIN OPENSSL)
# -------------------------------------------

set(ENABLE_FUSION OFF CACHE BOOL "Disable Fusion on Android" FORCE)
set(ENABLE_OPENSSL OFF CACHE BOOL "Disable OpenSSL on Android" FORCE)
set(ENABLE_MBEDTLS OFF CACHE BOOL "Disable mbedTLS on Android" FORCE)
set(ENABLE_MINICRYPTO ON CACHE BOOL "Enable minicrypto backend" FORCE)

set(PICOQUIC_DISABLE_AESNI ON CACHE BOOL "Disable AESNI (no x86 AES)" FORCE)
set(ENABLE_TRACER OFF CACHE BOOL "Disable tracing on Android" FORCE)

# Forzar minicrypto
add_definitions(-DPICOQUIC_NO_OPENSSL)
add_definitions(-DPICOQUIC_MINICRYPTO)

# ----- BLOQUEAR OPENSSL -----
set(OPENSSL_FOUND FALSE CACHE BOOL "No OpenSSL in Android" FORCE)
set(OPENSSL_INCLUDE_DIR "" CACHE STRING "" FORCE)
set(OPENSSL_CRYPTO_LIBRARY "" CACHE STRING "" FORCE)
set(OPENSSL_SSL_LIBRARY "" CACHE STRING "" FORCE)
set(OPENSSL_LIBRARIES "" CACHE STRING "" FORCE)

# ----- BLOQUEAR PICOTLS OPENSSL -----
set(PTLS_MINICRYPTO 1 CACHE BOOL "Enable minicrypto backend" FORCE)
set(PTLS_OPENSSL 0 CACHE BOOL "Disable OpenSSL backend" FORCE)
set(PTLS_MBEDTLS 0 CACHE BOOL "Disable mbedTLS backend" FORCE)
set(PTLS_FUSION 0 CACHE BOOL "Disable Fusion" FORCE)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DANDROID -fPIC")

# -------------------------------------------
# FUENTES PICOQUIC SIN OPENSSL
# -------------------------------------------

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
    picoquic/picoquic_ptls_minicrypto.c
)

# -------------------------------------------
# COMPILAR COMO LIBRERÍA
# -------------------------------------------

add_library(picoquic-core STATIC ${PICOQUIC_SOURCES})

target_include_directories(picoquic-core PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/picoquic)

find_package(Threads REQUIRED)
target_link_libraries(picoquic-core PUBLIC Threads::Threads)