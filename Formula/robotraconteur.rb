class Robotraconteur < Formula
  desc "Robot Raconteur: communication framework for robotics"
  homepage "https://robotraconteur.com"
  url "https://github.com/robotraconteur/robotraconteur/archive/v1.2.2.tar.gz"
  sha256 "8bed280aafaca602e6d85247dbf102b18724746a7e79d73f332c6e908422dea8"
  head "https://github.com/robotraconteur/robotraconteur.git"
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "openssl"

  def install
    system "cmake", ".", "-DBUILD_GEN=ON", "-DBoost_USE_STATIC_LIBS=ON",
           "-DOPENSSL_USE_STATIC_LIBS=ON", "-DCMAKE_BUILD_TYPE=Release", *std_cmake_args
    system "make", "install"
  end

  test do
    system "ctest", "-C", "Release"
  end
end
