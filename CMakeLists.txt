cmake_minimum_required(VERSION 3.13)
project(slipstream C)

# =======================================
# GLOBAL ANDROID BUILD FIXES
# =======================================

# Forzar NO usar OpenSSL
set(OPENSSL_USE_STATIC_LIBS OFF)
set(OPENSSL_ROOT_DIR "")
set(OPENSSL_INCLUDE_DIR "")
set(OPENSSL_CRYPTO_LIBRARY "")
set(OPENSSL_SSL_LIBRARY "")
set(OPENSSL_LIBRARIES "")

# PicoTLS: impedir uso de OpenSSL
set(PICOTLS_USE_OPENSSL OFF)
set(PTLS_USE_SYSTEM_OPENSSL OFF)

# Picoquic: no permitir que descargue picotls automáticamente
set(PICOQUIC_FETCH_PTLS OFF)

# Usar solo minicrypto en Android
set(PICOQUIC_USE_OPENSSL OFF)
set(PICOQUIC_USE_MINICRYPTO ON)

set(CMAKE_C_STANDARD 23)

# =======================================
# AGREGAR PICOQUIC DESDE extern/picoquic
# =======================================
add_subdirectory(extern/picoquic)

set(PICOQUIC_ADDITIONAL_C_FLAGS "" CACHE STRING "Additional C flags for picoquic")

# =======================================
# CONFIGURACIÓN DEL BUILD
# =======================================

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose the type of build." FORCE)
endif()

if(${CMAKE_BUILD_TYPE} STREQUAL "Debug")
    list(APPEND PICOQUIC_COMPILE_DEFINITIONS BUILD_LOGLIB)
    set(BUILD_LOGLIB ON)
else()
    set(BUILD_LOGLIB OFF)
endif()

if(POLICY CMP0048)
    cmake_policy(SET CMP0048 NEW)
endif()

# =======================================
# FUENTES COMUNES
# =======================================

set(COMMON_SOURCES
        src/slipstream_inline_dots.c
        src/slipstream_sockloop.c
        src/slipstream_utils.c
        include/slipstream.h
        include/slipstream_inline_dots.h
        include/slipstream_server_cc.h
        include/slipstream_slot.h
        include/slipstream_sockloop.h
        include/slipstream_utils.h

        extern/lua-resty-base-encoding/b32_data.h
        extern/lua-resty-base-encoding/base32.c
        extern/lua-resty-base-encoding/modp_stdint.h
        include/lua-resty-base-encoding-base32.h

        extern/SPCDNS/src/dns.h
        extern/SPCDNS/src/codec.c
        extern/SPCDNS/src/mappings.c
        extern/SPCDNS/src/mappings.h
        extern/SPCDNS/src/netsimple.c
        extern/SPCDNS/src/netsimple.h
        extern/SPCDNS/src/output.c
        extern/SPCDNS/src/output.h
)

# =======================================
# CLIENTE
# =======================================

add_executable(slipstream-client
        src/slipstream_client_cli.c
        src/slipstream_client.c
        ${COMMON_SOURCES}
)

target_link_libraries(slipstream-client PRIVATE m)
target_link_libraries(slipstream-client PRIVATE picoquic-core)

if (BUILD_LOGLIB)
    target_link_libraries(slipstream-client PRIVATE picoquic-log)
endif ()

target_include_directories(slipstream-client PRIVATE include)
target_include_directories(slipstream-client PRIVATE extern)
target_include_directories(slipstream-client PRIVATE extern/picoquic)

# =======================================
# SERVIDOR
# =======================================

add_executable(slipstream-server
        src/slipstream_server_cli.c
        src/slipstream_server.c
        src/slipstream_server_cc.c
        ${COMMON_SOURCES}
)

target_link_libraries(slipstream-server PRIVATE m)
target_link_libraries(slipstream-server PRIVATE picoquic-core)

if (BUILD_LOGLIB)
    target_link_libraries(slipstream-server PRIVATE picoquic-log)
endif ()

target_include_directories(slipstream-server PRIVATE include)
target_include_directories(slipstream-server PRIVATE extern)
target_include_directories(slipstream-server PRIVATE extern/picoquic)