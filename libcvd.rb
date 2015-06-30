require "formula"

class Libcvd < Formula
  homepage "http://www.edwardrosten.com/cvd/index.html"
  url "https://github.com/edrosten/libcvd.git", :revision => "cb15fa2b2a525fe9b41ba5abcf20994997c0c616"
  version "cb15fa2"

  depends_on 'toon'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'libpng'
  depends_on 'libdc1394'

  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--without-jpeg",
                          "--without-tiff",
                          "--without-lapack",
                          "--without-dc1394v2",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test libcvd`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end

__END__
diff --git a/cvd_src/image_io/cvdimage.cxx b/cvd_src/image_io/cvdimage.cxx
index cf60246..2c4294e 100644
--- a/cvd_src/image_io/cvdimage.cxx
+++ b/cvd_src/image_io/cvdimage.cxx
@@ -42,7 +42,7 @@
 #else
 	#include <stdint.h>
 
-	#ifdef __GNUC__
+	#if (defined CVD_INTERNAL_NEED_TR1)
 		#include <tr1/array>
 		using namespace std::tr1;
 	#else
diff --git a/cvd_src/nothread/runnable_batch.cc b/cvd_src/nothread/runnable_batch.cc
index 20644f8..e6bd49c 100644
--- a/cvd_src/nothread/runnable_batch.cc
+++ b/cvd_src/nothread/runnable_batch.cc
@@ -1,4 +1,5 @@
 #include "cvd/runnable_batch.h"
+#include <cvd/internal/shared_ptr.h>
 
 namespace CVD
 {
@@ -12,7 +13,7 @@ void RunnableBatch::join()
 	joined = 1;
 }
 
-void RunnableBatch::schedule(std::tr1::shared_ptr<Runnable> r)
+void RunnableBatch::schedule(CVD::STD::shared_ptr<Runnable> r)
 {
 	r->run();
 }

