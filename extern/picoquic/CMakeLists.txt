cmake_minimum_required(VERSION 3.13)

project(picoquic
    VERSION 1.1.40.0
    DESCRIPTION "picoquic library"
    LANGUAGES C CXX)

# ------------------------------
# ANDROID CONFIG (NO OPENSSL)
# ------------------------------

set(ENABLE_FUSION OFF CACHE BOOL "Disable Fusion" FORCE)
set(ENABLE_OPENSSL OFF CACHE BOOL "Disable OpenSSL backend" FORCE)
set(ENABLE_MBEDTLS OFF CACHE BOOL "Disable mbedTLS backend" FORCE)
set(ENABLE_MINICRYPTO ON CACHE BOOL "Enable Minicrypto backend" FORCE)

set(PICOQUIC_DISABLE_AESNI ON CACHE BOOL "Disable AESNI" FORCE)
set(ENABLE_TRACER OFF CACHE BOOL "Disable tracing" FORCE)

# FORCE PTLS MINICRYPTO
set(PTLS_USE_OPENSSL 0 CACHE BOOL "Do not use OpenSSL" FORCE)
set(PTLS_USE_MBEDTLS 0 CACHE BOOL "Do not use mbedTLS" FORCE)
set(PTLS_USE_MINICRYPTO 1 CACHE BOOL "Use Minicrypto only" FORCE)
set(PTLS_USE_SYSTEM_OPENSSL 0 CACHE BOOL "No system OpenSSL" FORCE)
set(PTLS_FUSION 0 CACHE BOOL "Disable Fusion" FORCE)

add_definitions(-DPICOQUIC_NO_OPENSSL)
add_definitions(-DPICOQUIC_MINICRYPTO)

# BLOCK ALL OPENSSL CHECKS
set(OPENSSL_FOUND FALSE CACHE BOOL "OpenSSL disabled for Android" FORCE)
set(OPENSSL_INCLUDE_DIR "" CACHE STRING "" FORCE)
set(OPENSSL_CRYPTO_LIBRARY "" CACHE STRING "" FORCE)
set(OPENSSL_SSL_LIBRARY "" CACHE STRING "" FORCE)
set(OPENSSL_LIBRARIES "" CACHE STRING "" FORCE)

message(STATUS "Android build: OpenSSL disabled → Using Minicrypto only")

find_package(Threads REQUIRED)

# ------------------------------
# SOURCES (COMPLETOS)
# ------------------------------

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
    picoquic/sacks.c
    picoquic/skip_frame.c
    picoquic/ticket_store.c
    picoquic/wrapper.c
)

# ------------------------------
# LIBRARY
# ------------------------------
add_library(picoquic-core STATIC ${PICOQUIC_SOURCES})

target_include_directories(picoquic-core PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/picoquic
)

target_link_libraries(picoquic-core PUBLIC Threads::Threads)