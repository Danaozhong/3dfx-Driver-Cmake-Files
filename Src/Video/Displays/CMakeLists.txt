CMAKE_MINIMUM_REQUIRED(VERSION 3.10)

PROJECT(3dfxvs VERSION 1.0 DESCRIPTION "Win2k/XP Voodoo4/5 Display Driver" LANGUAGES C ASM_MASM)

OPTION(BUILD_32BIT "Build for 32-bit targets, otherwise x64" ON)


# Compile with Windows SDK 7.1
set (CMAKE_SYSTEM_VERSION 7.1)
#set(CMAKE_GENERATOR_TOOLSET "v120_xp" CACHE STRING "CMAKE_GENERATOR_TOOLSET" FORCE)
#set(CMAKE_VS_PLATFORM_TOOLSET "v120_xp" CACHE STRING "CMAKE_VS_PLATFORM_TOOLSET" FORCE)

SET(WINDDK_PATH "D:/Programs/WindowsSDK/DDK/" CACHE STRING "Path to windows driver kit")
SET(WINSDK_PATH "D:/Programs/WindowsSDK/v71/" CACHE STRING "Path to windows sdk")
SET(DIRECTX8SDK_PATH "D:/Programs/WindowsSDK/DX81SDK/DXSDK/" CACHE STRING "Path to windows directx sdk")


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

set(DRIVER_SOURCES 
    ${CMAKE_SOURCE_DIR}/H5/afifo.c
    ${CMAKE_SOURCE_DIR}/H5/bitblt.c
    ${CMAKE_SOURCE_DIR}/H5/bltmm.c
    ${CMAKE_SOURCE_DIR}/H5/brush.c
    ${CMAKE_SOURCE_DIR}/H5/cfifo.c
    ${CMAKE_SOURCE_DIR}/H5/clip.c
    ${CMAKE_SOURCE_DIR}/H5/color.c
    ${CMAKE_SOURCE_DIR}/H5/colorapi.c
    ${CMAKE_SOURCE_DIR}/H5/d3contxt.c
    ${CMAKE_SOURCE_DIR}/H5/d3fog.c
    ${CMAKE_SOURCE_DIR}/H5/d3global.c
    ${CMAKE_SOURCE_DIR}/H5/d3init.c
    ${CMAKE_SOURCE_DIR}/H5/d3rstate.c
    ${CMAKE_SOURCE_DIR}/H5/d3stubs.c
    ${CMAKE_SOURCE_DIR}/H5/d3txtr.c
    ${CMAKE_SOURCE_DIR}/H5/d6dp2.c
    ${CMAKE_SOURCE_DIR}/H5/d6fan.c
    # ${CMAKE_SOURCE_DIR}/H5/d6fani.c -> file in included internally from other C file. Gosh
    ${CMAKE_SOURCE_DIR}/H5/d6fvf.c
    ${CMAKE_SOURCE_DIR}/H5/d6line.c
    ${CMAKE_SOURCE_DIR}/H5/d6mt.c
    ${CMAKE_SOURCE_DIR}/H5/d6point.c
    ${CMAKE_SOURCE_DIR}/H5/d6strip.c
    #${CMAKE_SOURCE_DIR}/H5/d6stripi.c -> file in included internally from other C file. Gosh
    ${CMAKE_SOURCE_DIR}/H5/d6tri2.c
    #${CMAKE_SOURCE_DIR}/H5/d6tri2i.c -> file in included internally from other C file. Gosh
    ${CMAKE_SOURCE_DIR}/H5/d7d3d.c
    ${CMAKE_SOURCE_DIR}/H5/d7dp2.c
    ${CMAKE_SOURCE_DIR}/H5/d7fvfext.c
    ${CMAKE_SOURCE_DIR}/H5/ddblt32.c
    ${CMAKE_SOURCE_DIR}/H5/ddflip.c
    ${CMAKE_SOURCE_DIR}/H5/ddfxnt.c
    ${CMAKE_SOURCE_DIR}/H5/ddinit.c
    ${CMAKE_SOURCE_DIR}/H5/ddmemmgr.c
    ${CMAKE_SOURCE_DIR}/H5/ddovl32.c
    ${CMAKE_SOURCE_DIR}/H5/ddsli2d.c
    ${CMAKE_SOURCE_DIR}/H5/ddsliblt.c
    ${CMAKE_SOURCE_DIR}/H5/ddstubs.c
    ${CMAKE_SOURCE_DIR}/H5/ddsurf.c
    ${CMAKE_SOURCE_DIR}/H5/ddvpe32.c
    ${CMAKE_SOURCE_DIR}/H5/debug.c
    ${CMAKE_SOURCE_DIR}/H5/dfpapi.c
    ${CMAKE_SOURCE_DIR}/H5/edgeesc.c
    ${CMAKE_SOURCE_DIR}/H5/enable.c
    ${CMAKE_SOURCE_DIR}/H5/escape.c
    ${CMAKE_SOURCE_DIR}/H5/fastfill.c
    ${CMAKE_SOURCE_DIR}/H5/fillpath.c
    ${CMAKE_SOURCE_DIR}/H5/funcapi.c
    ${CMAKE_SOURCE_DIR}/H5/fxexp.c
    ${CMAKE_SOURCE_DIR}/H5/fxf2i.c
    ${CMAKE_SOURCE_DIR}/H5/fxt.c
    ${CMAKE_SOURCE_DIR}/H5/glicd.c
    ${CMAKE_SOURCE_DIR}/H5/heap.c
    #${CMAKE_SOURCE_DIR}/H5/heap5.c <- included by heap.c
    ${CMAKE_SOURCE_DIR}/H5/hwcext.c
    ${CMAKE_SOURCE_DIR}/H5/light.c
    ${CMAKE_SOURCE_DIR}/H5/lines.c
    ${CMAKE_SOURCE_DIR}/H5/lineto.c
    ${CMAKE_SOURCE_DIR}/H5/logfile.c
    ${CMAKE_SOURCE_DIR}/H5/memcheck.c
    ${CMAKE_SOURCE_DIR}/H5/misc.c
    ${CMAKE_SOURCE_DIR}/H5/multi.c
    ${CMAKE_SOURCE_DIR}/H5/paint.c
    ${CMAKE_SOURCE_DIR}/H5/palette.c
    ${CMAKE_SOURCE_DIR}/H5/pointer.c
    ${CMAKE_SOURCE_DIR}/H5/procprim.c
    ${CMAKE_SOURCE_DIR}/H5/qmodes.c
    ${CMAKE_SOURCE_DIR}/H5/soalight.c
    ${CMAKE_SOURCE_DIR}/H5/soaprim.c
    ${CMAKE_SOURCE_DIR}/H5/stretch.c
    ${CMAKE_SOURCE_DIR}/H5/strips.c
    ${CMAKE_SOURCE_DIR}/H5/tcutils.c
    ${CMAKE_SOURCE_DIR}/H5/textout.c
    ${CMAKE_SOURCE_DIR}/H5/thunk.c
    ${CMAKE_SOURCE_DIR}/H5/tlclip.c
    ${CMAKE_SOURCE_DIR}/H5/tlutil.c
    ${CMAKE_SOURCE_DIR}/H5/tnldp2.c
    ${CMAKE_SOURCE_DIR}/H5/tnlinit.c
    ${CMAKE_SOURCE_DIR}/H5/tvout.c
    ${CMAKE_SOURCE_DIR}/H5/xform.c
)




set (ASM_SOURCES
    # these files must be compiled with the MASM compiler
    ${CMAKE_SOURCE_DIR}/H5/I386/amesh2.asm
    ${CMAKE_SOURCE_DIR}/H5/I386/atri.asm
    ${CMAKE_SOURCE_DIR}/H5/i386/afan.asm
    ${CMAKE_SOURCE_DIR}/H5/i386/cpu.asm
    ${CMAKE_SOURCE_DIR}/H5/i386/axtrikni.asm
    ${CMAKE_SOURCE_DIR}/H5/i386/axtrik.asm
    ${CMAKE_SOURCE_DIR}/H5/i386/k6_2.asm
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
    ${DRIVER_SOURCES}
    ${CMAKE_SOURCE_DIR}/H5/XFORM.C
#    ${GLIDE_OUTSIDE_SOURCES}
    ${ASM_SOURCES}
)

# Visual Studio: Disable SAFESEH, otherwise linker will complain about the asm files
#target_link_options(${CMAKE_PROJECT_NAME} PUBLIC "-SAFESEH:NO")
target_link_options(${CMAKE_PROJECT_NAME} PUBLIC "$<$<C_COMPILER_ID:MSVC>:-SAFESEH:NO>")

target_include_directories(${CMAKE_PROJECT_NAME} PUBLIC
    ${CMAKE_SOURCE_DIR}/INC
    ${CMAKE_SOURCE_DIR}/H5
)


    
target_include_directories(${CMAKE_PROJECT_NAME} PUBLIC
    ${WINDDK_PATH}/inc/wxp
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
    -DWINNT
    #-D_WIN32_WINNT_WIN2K=0x0500 # win2k
    -D_WIN32_WINNT_WINXP=0x0501 # Windows XP
    -D_WIN32_WINNT=0x0501
    -DUSE_DDRAW_CODE

    
    
    -DENABLE_RECONFIG_VIDMEM
    -DDX=8 # Compile with DX8 support
    -DDXDDKVERSION=8 # User DirectX8 DDK
    
    -DMS_VIEW # some windows xp stuff
)

target_compile_definitions(${CMAKE_PROJECT_NAME} PUBLIC
    -DA0_SILICON  # hardware silicon (A0)
    -DH3_B0  # hardware revision (B0)
    -DDINCSTBPERF
)


# If use command FIFO
target_compile_definitions(${CMAKE_PROJECT_NAME} PUBLIC
    -DH3_FIFO
    -DCMDFIFO
)



# If DirectDraw support
target_compile_definitions(${CMAKE_PROJECT_NAME} PUBLIC
    -DUSE_DDRAW_CODE
)

# if support 3D rendering
target_compile_definitions(${CMAKE_PROJECT_NAME} PUBLIC
    -DUSE_D3D_CODE
    -DNUMTEXTUREUNITS=2
)

# if support Anti-aliasing
target_compile_definitions(${CMAKE_PROJECT_NAME} PUBLIC
    -DSLI_AA
)


if(CMAKE_BUILD_TYPE MATCHES DEBUG)
    target_compile_definitions(${CMAKE_PROJECT_NAME} PUBLIC

        -DGDBG_INFO_ON 
    )
endif()



    
    
# OS-specific-specific defines
if(WIN32)
    
    # All attributes starting with "_NASM" are needed to be able to build the asm sources correctly.
    # The *.asm files contain os-specific sections, that are switched using the defines below.
    # NASM does not provide any _WIN32 or unix defines, so we have to add them ourselves.
    target_compile_definitions(${CMAKE_PROJECT_NAME} PUBLIC
        _NASM_BUILD_FOR_WIN32
    )
    
else()
    target_compile_definitions(${CMAKE_PROJECT_NAME} PUBLIC
        _NASM_BUILD_FOR_LINUX
    )
endif()


target_link_libraries(${CMAKE_PROJECT_NAME} PUBLIC
    ${WINDDK_PATH}/lib/wxp/i386/win32k.lib
    #${WINDDK_PATH}/lib/wxp/i386/libcntpr.lib
)

#gcc -o fxgasm -Wall -I. -I../../incsrc -I../../init -I../../../swlibs/fxmisc -I../../../swlibs/newpci/pcilib -I../../../swlibs/fxmemmap #-I../../../swlibs/texus2/lib -DGLIDE3 -DGLIDE3_ALPHA -DGLIDE_HW_TRI_SETUP=1 -DGLIDE_PACKED_RGB=0 -DGLIDE_PACKET3_TRI_SETUP=1 -DGLIDE_TRI_CULLING=1# -DUSE_PACKET_FIFO=1 -DGLIDE_DISPATCH_SETUP -DGLIDE_DISPATCH_DOWNLOAD -DGLIDE_CHIP_BROADCAST=1 -DGLIDE_BLIT_CLEAR=1 -DCVG -DGL_MMX -DGL_AMD3D -DGL_X86 -O1 -ffast-math fxgasm.c