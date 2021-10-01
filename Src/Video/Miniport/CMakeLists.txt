CMAKE_MINIMUM_REQUIRED(VERSION 3.10)

PROJECT(3dfxvsm VERSION 1.0 DESCRIPTION "Win2k/XP Voodoo4/5 Display Driver" LANGUAGES C ASM_MASM)

OPTION(BUILD_32BIT "Build for 32-bit targets, otherwise x64" ON)


# Compile with Windows SDK 7.1
set (CMAKE_SYSTEM_VERSION 7.1)
#set(CMAKE_GENERATOR_TOOLSET "v120_xp" CACHE STRING "CMAKE_GENERATOR_TOOLSET" FORCE)
#set(CMAKE_VS_PLATFORM_TOOLSET "v120_xp" CACHE STRING "CMAKE_VS_PLATFORM_TOOLSET" FORCE)

SET(WINDDK_PATH "D:/Programs/WindowsSDK/DDK" CACHE STRING "Path to windows driver kit")
SET(WINSDK_PATH "D:/Programs/WindowsSDK/v71" CACHE STRING "Path to windows sdk")
SET(DIRECTX8SDK_PATH "D:/Programs/WindowsSDK/DX81SDK/DXSDK" CACHE STRING "Path to windows directx sdk")


# Set the configuration for the assembler
if (${BUILD_32BIT})
    if(MSVC)
        # Nothing to do - MSVC supports building 32bit using a different cmake invokation
    else()
        # Set this flag for the compiler and linker
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m32")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m32")
        SET(CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} -m32")
    endif()
        
    # tell the assembler to generate 32 bit files
    if (WIN32)
        set(CMAKE_ASM_NASM_OBJECT_FORMAT win32)
    else()
        set(CMAKE_ASM_NASM_OBJECT_FORMAT elf32)
    endif()
else()
    if (WIN32)
        set(CMAKE_ASM_NASM_OBJECT_FORMAT win64)
    else()
        set(CMAKE_ASM_NASM_OBJECT_FORMAT elf64)
    endif()
endif()

if (WIN32)
#    set(CMAKE_ASM_NASM_DEFINITIONS ${CMAKE_ASM_NASM_DEFINITIONS}
#        -D_NASM_BUILD_FOR_WIN32
#    )
else()
#    set(CMAKE_ASM_NASM_DEFINITIONS ${CMAKE_ASM_NASM_DEFINITIONS}
#        -D_NASM_BUILD_FOR_LINUX
#    )
endif()


#set(CMAKE_ASM_NASM_COMPILE_OBJECT "<CMAKE_ASM_NASM_COMPILER> <INCLUDES> \
#    <FLAGS> -DGLIDE_PACKED_RGB ${CMAKE_ASM_NASM_DEFINITIONS} -f ${CMAKE_ASM_NASM_OBJECT_FORMAT} -o <OBJECT> <SOURCE>")
    

#set (NEWPCI_LIB_DIR ${CMAKE_SOURCE_DIR}/../../swlibs/newpci/pcilib)

set(MINIPORT_SOURCES 
    ${CMAKE_SOURCE_DIR}/H5/bt868.c       
    ${CMAKE_SOURCE_DIR}/H5/ddc.c         
    ${CMAKE_SOURCE_DIR}/H5/debug.c       
    ${CMAKE_SOURCE_DIR}/H5/dfp.c         
    ${CMAKE_SOURCE_DIR}/H5/di_i2c.c      
    ${CMAKE_SOURCE_DIR}/H5/ds_i2c.c      
    ${CMAKE_SOURCE_DIR}/H5/h3.c          
    ${CMAKE_SOURCE_DIR}/H5/h3data.c      
    ${CMAKE_SOURCE_DIR}/H5/h3modes.c     
    ${CMAKE_SOURCE_DIR}/H5/h3modeset.c   
    ${CMAKE_SOURCE_DIR}/H5/h3modetab.c  
    ${CMAKE_SOURCE_DIR}/H5/h3registry.c 
    ${CMAKE_SOURCE_DIR}/H5/mapmem.c       
    ${CMAKE_SOURCE_DIR}/H5/nvram.c       
    ${CMAKE_SOURCE_DIR}/H5/pci.c
    ${CMAKE_SOURCE_DIR}/H5/power.c
    ${CMAKE_SOURCE_DIR}/H5/kmvt.c
    ${CMAKE_SOURCE_DIR}/H5/sliaa.c
    ${CMAKE_SOURCE_DIR}/H5/vmipld.c
    ${CMAKE_SOURCE_DIR}/H5/voodoo3.rc
)




set (ASM_SOURCES
    # these files must be compiled with the MASM compiler
    ${CMAKE_SOURCE_DIR}/H5/I386/p6test.asm
)

set(GLIDE_OUTSIDE_SOURCES

)

# platform specific compile files
set(WINDOWS_DEPENDENCIES
)

set(LINUX_DEPENDENCIES
)

if(WIN32)
    set(GLIDE_OUTSIDE_SOURCES ${GLIDE_OUTSIDE_SOURCES}
       ${WINDOWS_DEPENDENCIES}
    )    
else()
    set(GLIDE_OUTSIDE_SOURCES ${GLIDE_OUTSIDE_SOURCES}
       ${LINUX_DEPENDENCIES} 
    )
endif()

# Create a shared library 
add_library(${CMAKE_PROJECT_NAME} SHARED 
    ${MINIPORT_SOURCES}
    ${ASM_SOURCES}
)

# Visual Studio: Disable SAFESEH, otherwise linker will complain about the asm files
#target_link_options(${CMAKE_PROJECT_NAME} PUBLIC "-SAFESEH:NO")
target_link_options(${CMAKE_PROJECT_NAME} PUBLIC "$<$<C_COMPILER_ID:MSVC>:-SAFESEH:NO>")

target_include_directories(${CMAKE_PROJECT_NAME} PUBLIC
    ${CMAKE_SOURCE_DIR}/INC
    ${CMAKE_SOURCE_DIR}/H5
    ${CMAKE_SOURCE_DIR}/../inc
)


    
target_include_directories(${CMAKE_PROJECT_NAME} PUBLIC
    ${WINDDK_PATH}/inc/wxp
    ${WINDDK_PATH}/inc/ddk/wxp
    ${WINDDK_PATH}/inc/ddk/wdm/wxp
    ${WINSDK_PATH}/Include
    ${DIRECTX8SDK_PATH}/include
)

if(MSVC)
  # disable all warnings for now (too many)
  target_compile_options(${CMAKE_PROJECT_NAME} PRIVATE /W0)
else()
  target_compile_options(${CMAKE_PROJECT_NAME} PRIVATE -Wall -Wextra -Wpedantic)
endif()


target_compile_definitions(${CMAKE_PROJECT_NAME} PUBLIC
    -DGRAPHICS_CLOCK=166 
    -DINCSTBCUST
    
    -DAGP_FIFO_CODE  # support AGP fifo
    -DAGP_CMD_FIFO # this is also needed
    -DSLI_AA # support AA
    
    -D_X86_ # build for x86
    -DWINNT
    #-D_WIN32_WINNT_WIN2K=0x0500 # win2k
    -D_WIN32_WINNT_WINXP=0x0501 # Windows XP
    -D_WIN32_WINNT=0x0501
    -D_NTOSDEF_ # needed for video.h when building on NTOS systems
    -D_NTOS_
   
)



if(CMAKE_BUILD_TYPE MATCHES DEBUG)
    target_compile_definitions(${CMAKE_PROJECT_NAME} PUBLIC

    )
endif()



    

target_link_libraries(${CMAKE_PROJECT_NAME} PUBLIC
    ${WINDDK_PATH}/lib/wxp/i386/videoprt.lib
    ${WINDDK_PATH}/lib/wxp/i386/ntoskrnl.lib
    ${WINDDK_PATH}/lib/wxp/i386/hal.lib
    #${WINDDK_PATH}/lib/wxp/i386/libcntpr.lib
)

#gcc -o fxgasm -Wall -I. -I../../incsrc -I../../init -I../../../swlibs/fxmisc -I../../../swlibs/newpci/pcilib -I../../../swlibs/fxmemmap #-I../../../swlibs/texus2/lib -DGLIDE3 -DGLIDE3_ALPHA -DGLIDE_HW_TRI_SETUP=1 -DGLIDE_PACKED_RGB=0 -DGLIDE_PACKET3_TRI_SETUP=1 -DGLIDE_TRI_CULLING=1# -DUSE_PACKET_FIFO=1 -DGLIDE_DISPATCH_SETUP -DGLIDE_DISPATCH_DOWNLOAD -DGLIDE_CHIP_BROADCAST=1 -DGLIDE_BLIT_CLEAR=1 -DCVG -DGL_MMX -DGL_AMD3D -DGL_X86 -O1 -ffast-math fxgasm.c