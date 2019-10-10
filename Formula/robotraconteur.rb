class Robotraconteur < Formula
  desc "Robot Raconteur: communication framework for robotics"
  homepage "https://robotraconteur.com"
  url "https://github.com/robotraconteur/robotraconteur/archive/v0.9.1.tar.gz"
  sha256 "fd5567659bdb20aabfbc844bea2d996281a104118e6721702746f0ca4561b128"
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
