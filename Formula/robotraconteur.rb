class Robotraconteur < Formula
  desc "Robot Raconteur: communication framework for robotics"
  homepage "https://robotraconteur.com"
  url "https://github.com/robotraconteur/robotraconteur/archive/v0.14.1.tar.gz"
  sha256 "7c4185f31108f203a787354495503a0be7d916f40a8d472cf459a5f45be9bfb8"
  head "https://github.com/robotraconteur/robotraconteur.git"
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "openssl"

  def install
    system "cmake", ".", "-DCMAKE_CXX_STANDARD=11", "-DBUILD_GEN=ON", "-DBoost_USE_STATIC_LIBS=ON",
           "-DOPENSSL_USE_STATIC_LIBS=ON", "-DCMAKE_BUILD_TYPE=Release", *std_cmake_args
    system "make", "install"
  end

  test do
    system "ctest", "-C", "Release"
  end
end
