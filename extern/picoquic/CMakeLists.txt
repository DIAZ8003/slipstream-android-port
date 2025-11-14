cmake_minimum_required(VERSION 3.13)

project(picoquic
    VERSION 1.1.40.0
    DESCRIPTION "picoquic library"
    LANGUAGES C CXX)

# THREADS
find_package(Threads REQUIRED)

# =======================
# CONFIGURACIÓN ANDROID
# =======================
set(ENABLE_FUSION OFF CACHE BOOL "Disable Fusion on Android")
set(ENABLE_OPENSSL OFF CACHE BOOL "Disable OpenSSL on Android")
set(ENABLE_MBEDTLS OFF CACHE BOOL "Disable mbedTLS on Android")
set(ENABLE_MINICRYPTO ON CACHE BOOL "Enable minicrypto on Android")
set(PICOQUIC_DISABLE_AESNI ON CACHE BOOL "Disable AESNI on Android")
set(ENABLE_TRACER OFF CACHE BOOL "Disable USDT/tracing")

# Forzar minicrypto
add_definitions(-DPICOQUIC_NO_OPENSSL)
add_definitions(-DPICOQUIC_MINICRYPTO)

# Evitar que picoquic busque OpenSSL
set(OPENSSL_FOUND FALSE)
set(OPENSSL_INCLUDE_DIR "")
set(OPENSSL_CRYPTO_LIBRARY "")
set(OPENSSL_SSL_LIBRARY "")
set(OPENSSL_LIBRARIES "")

# Evitar autodetecciones internas de picotls
set(PTLS_WITH_FUSION 0)
set(PTLS_WITH_OPENSSL 0)
set(PTLS_WITH_MBEDTLS 0)
set(PTLS_WITH_MINICRYPTO 1)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DANDROID -fPIC")

# =======================
# FUENTES
# =======================
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

# =======================
# LIBRERÍA
# =======================
add_library(picoquic-core STATIC ${PICOQUIC_SOURCES})

target_include_directories(picoquic-core PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/picoquic)

target_link_libraries(picoquic-core PUBLIC Threads::Threads)