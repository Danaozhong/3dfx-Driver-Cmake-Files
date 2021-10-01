mkdir bin_msvc_docker
pushd bin_msvc_docker
cmake -G "Visual Studio 12 2013" -DWINDDK_PATH=C:/libs/win_ddk -DWINSDK_PATH=C:/libs/win_sdk_v71 -DDIRECTX8SDK_PATH=C:/libs/dx_sdk_v81 -A Win32 ..
popd