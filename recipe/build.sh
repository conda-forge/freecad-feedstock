if [[ ${FEATURE_DEBUG} = 1 ]]; then
      BUILD_TYPE="Debug"
else
      BUILD_TYPE="Release"
fi



declare -a CMAKE_PLATFORM_FLAGS


if [[ ${HOST} =~ .*darwin.* ]]; then
  CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

# Ensure the build uses the correct Qt tools
if [[ "${target_platform}" =~ osx-arm64 ]]; then
    rm -f "${PREFIX}/lib/qt6/moc"
    rm -f "${PREFIX}/lib/qt6/uic"
    rm -f "${PREFIX}/lib/qt6/rcc"
    rm -f "${PREFIX}/lib/qt6/bin/lrelease"
    ln -s "${BUILD_PREFIX}/lib/qt6/moc" "${PREFIX}/lib/qt6/moc"
    ln -s "${BUILD_PREFIX}/lib/qt6/uic" "${PREFIX}/lib/qt6/uic"
    ln -s "${BUILD_PREFIX}/lib/qt6/rcc" "${PREFIX}/lib/qt6/rcc"
    ln -s "${BUILD_PREFIX}/lib/qt6/bin/lrelease" "${PREFIX}/lib/qt6/bin/lrelease"
    
    # Additional debugging information
    echo "Adjusted Qt tools for osx-arm64 with build variant qt6"
    echo "Removed: ${PREFIX}/lib/qt6/moc"
    echo "Linked to: ${BUILD_PREFIX}/lib/qt6/moc"
    echo "Removed: ${PREFIX}/lib/qt6/uic"
    echo "Linked to: ${BUILD_PREFIX}/lib/qt6/uic"
    echo "Removed: ${PREFIX}/lib/qt6/rcc"
    echo "Linked to: ${BUILD_PREFIX}/lib/qt6/rcc"
    echo "Removed: ${PREFIX}/lib/qt6/bin/lrelease"
    echo "Linked to: ${BUILD_PREFIX}/lib/qt6/bin/lrelease"
else
    echo "Skipping Qt tools adjustment. Target platform: ${target_platform}, Build variant: $build_variant"
fi

cmake -G "Ninja" -B build -S . \
      -D BUILD_WITH_CONDA:BOOL=ON \
      -D CMAKE_BUILD_TYPE=${BUILD_TYPE} \
      -D CMAKE_INSTALL_PREFIX:FILEPATH="$PREFIX" \
      -D CMAKE_PREFIX_PATH:FILEPATH="$PREFIX" \
      -D CMAKE_LIBRARY_PATH:FILEPATH="$PREFIX/lib" \
      -D CMAKE_INSTALL_LIBDIR:FILEPATH="$PREFIX/lib" \
      -D CMAKE_INCLUDE_PATH:FILEPATH="$PREFIX/include" \
      -D FREECAD_USE_OCC_VARIANT="Official Version" \
      -D OCC_INCLUDE_DIR:FILEPATH="$PREFIX/include" \
      -D USE_BOOST_PYTHON:BOOL=OFF \
      -D FREECAD_USE_PYBIND11:BOOL=ON \
      -D SMESH_INCLUDE_DIR:FILEPATH="$PREFIX/include/smesh" \
      -D FREECAD_USE_EXTERNAL_SMESH=ON \
      -D FREECAD_USE_EXTERNAL_FMT:BOOL=OFF \
      -D BUILD_FLAT_MESH:BOOL=ON \
      -D BUILD_WITH_CONDA:BOOL=ON \
      -D Python_EXECUTABLE:FILEPATH="$PYTHON" \
      -D Python3_EXECUTABLE:FILEPATH="$PYTHON" \
      -D BUILD_FEM_NETGEN:BOOL=ON \
      -D BUILD_SHIP:BOOL=OFF \
      -D OCCT_CMAKE_FALLBACK:BOOL=OFF \
      -D FREECAD_USE_QT_DIALOG:BOOL=ON \
      -D BUILD_DYNAMIC_LINK_PYTHON:BOOL=OFF \
      -D Boost_NO_BOOST_CMAKE:BOOL=ON \
      -D FREECAD_USE_PCL:BOOL=ON \
      -D FREECAD_USE_PCH:BOOL=OFF \
      -D INSTALL_TO_SITEPACKAGES:BOOL=ON \
      -D QT_HOST_PATH="${PREFIX}" \
      -D FREECAD_USE_SHIBOKEN:BOOL=OFF \
      -D FREECAD_USE_PYSIDE:BOOL=OFF \
      -D FREECAD_CHECK_PIVY:BOOL=OFF \
      ${CMAKE_PLATFORM_FLAGS[@]}

echo "FREECAD_USE_3DCONNEXION=${FREECAD_USE_3DCONNEXION}"

ninja -C build install
rm -r ${PREFIX}/share/doc/FreeCAD     # smaller size of package!
mv ${PREFIX}/bin/FreeCAD ${PREFIX}/bin/freecad
mv ${PREFIX}/bin/FreeCADCmd ${PREFIX}/bin/freecadcmd
