require "formula"

class Toon < Formula
  homepage "http://www.edwardrosten.com/cvd/toon.html"
  url "http://www.edwardrosten.com/cvd/TooN-2.2.tar.gz"
  sha1 "f2d641d9b6f4b599d69cb756805e9119c8096816"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test TooN`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
