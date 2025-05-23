{ lib 
, stdenv
, cmake
, makeWrapper
, doctest
, glfw
, glm
, stduuid
, nlohmann_json
, zstd
, miniaudio
, fetchFromGitHub
}:

let
  libdwarf-lite = fetchFromGitHub {
    owner = "jeremy-rifkin";
    repo = "libdwarf-lite";
    rev = "main";
    sha256 = "sha256-S2KDfWqqdQfK5+eQny2X5k0A5u9npkQ8OFRLBmTulao=";
  };

  cpptrace = fetchFromGitHub {
    owner = "jeremy-rifkin";
    repo = "cpptrace";
    rev = "main";
    sha256 = "sha256-w1KObCtzEyYGsH1GuNkKBL/6EfybeAFi1JTili2X8fU=";
  };

  glad = fetchFromGitHub {
    owner = "GameDevTecnico";
    repo = "cubos-glad";
    rev = "bdf4d66072830f9822512f8f7dc3ca3fd72d9f69";
    sha256 = "sha256-jG9ZhbdbUBIjyEFOOoyiywK7gMvzr8tb2BxHO87JUyg=";
  };

  stb_image = fetchFromGitHub {
    owner = "GameDevTecnico";
    repo = "cubos-stb";
    rev = "5c340b5ee24ac74e69bf92b5bacdfbac6bbaa4a8";
    sha256 = "sha256-D4fWoezHR+rp3Ecnlj6BhaVu5IhB7Yr2cJH2dgFHZnY=";
  };

  freetype = fetchFromGitHub {
    owner = "freetype";
    repo = "freetype";
    rev = "VER-2-13-3";
    sha256 = "sha256-4l90lDtpgm5xlh2m7ifrqNy373DTRTULRkAzicrM93c=";
  };

  msdfgen = fetchFromGitHub {
    owner = "GameDevTecnico";
    repo = "cubos-msdfgen";
    rev = "7293c65d49219c0dea71c5c59760c7df7f452e71";
    sha256 = "sha256-y/luplRQex6fI3qi1uoP6ViLVCi+gKNbRHltggkKhVQ=";
  };

  msdf-atlas-gen = fetchFromGitHub {
    owner = "Chlumsky";
    repo = "msdf-atlas-gen";
    rev = "v1.3";
    sha256 = "sha256-SfzQ008aoYI8tkrHXsXVQq9Qq+NIqT1zvSIHK1LTbLU=";
  };

  imgui = fetchFromGitHub {
    owner = "ocornut";
    repo = "imgui";
    rev = "v1.89.9-docking";
    sha256 = "sha256-0k9jKrJUrG9piHNFQaBBY3zgNIKM23ZA879NY+MNYTU=";
  };

  implot = fetchFromGitHub {
    owner = "epezent";
    repo = "implot";
    rev = "1f7a8c0314d838a76695bccebe0f66864f507bc0";
    sha256 = "sha256-7tBfG6hZrLKAL65q667XDx+n6bfgbUqtsmho+q/h+nE=";
  };

in

stdenv.mkDerivation {
  name = "cubos";
  version = "main";

  src = ./.;

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = [ doctest glfw glm stduuid nlohmann_json ];

  cmakeFlags = with lib; [
    (cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (cmakeOptionType "path" "FETCHCONTENT_SOURCE_DIR_GLAD" "${glad}")
    (cmakeOptionType "path" "FETCHCONTENT_SOURCE_DIR_STB_IMAGE" "${stb_image}")
    (cmakeOptionType "path" "FETCHCONTENT_SOURCE_DIR_FREETYPE" "${freetype}")
    (cmakeOptionType "path" "FETCHCONTENT_SOURCE_DIR_MSDFGEN" "${msdfgen}")
    (cmakeOptionType "path" "FETCHCONTENT_SOURCE_DIR_MSDF-ATLAS-GEN" "${msdf-atlas-gen}")
    (cmakeOptionType "path" "FETCHCONTENT_SOURCE_DIR_IMGUI" "${imgui}")
    (cmakeOptionType "path" "FETCHCONTENT_SOURCE_DIR_IMPLOT" "${implot}")
    (cmakeOptionType "path" "FETCHCONTENT_SOURCE_DIR_LIBDWARF" "${libdwarf-lite}")
    (cmakeOptionType "path" "FETCHCONTENT_SOURCE_DIR_ZSTD" "${zstd}")
    (cmakeOptionType "path" "FETCHCONTENT_SOURCE_DIR_CPPTRACE" "${cpptrace}")
    (cmakeOptionType "path" "FETCHCONTENT_SOURCE_DIR_MINIAUDIO" "${miniaudio}")
    (cmakeBool "CUBOS_CORE_SAMPLES" false)
    (cmakeBool "CUBOS_CORE_TESTS" false)
    (cmakeBool "CUBOS_ENGINE_SAMPLES" false)
    (cmakeBool "CUBOS_ENGINE_TESTS" false)
    (cmakeBool "TESSERATOS_DISTRIBUTE" true)
    (cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (cmakeFeature "CMAKE_INSTALL_DATADIR" "share")
  ];

  postInstall = ''
    mv $out/bin/tesseratos $out/bin/tesseratos-wrapped
    echo "#!/usr/bin/env bash" > $out/bin/tesseratos
    echo "cd $out/share/tesseratos" >> $out/bin/tesseratos
    echo "exec $out/bin/tesseratos-wrapped \"settings.path=\$HOME/.config/tesseratos.json\" \"\$@\"" >> $out/bin/tesseratos
    chmod +x $out/bin/tesseratos
  '';

  meta = with lib; {
    homepage = "https://cubosengine.org";
    description = "A modern C++ game engine";
    license = licenses.mit;
    platforms = with platforms; linux ++ darwin;
  };
}
