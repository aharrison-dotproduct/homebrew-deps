# Copyright (c) 2013, Toshiki TAKEUCHI
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#  1. Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#  2. Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# This formula was taken from the totakke/homebrew-openni2 tap of
# Toshiki Takeuchi
# https://github.com/totakke/homebrew-openni2
#
# CHANGES:
# 10/05/2014 arh
#  - Modified include dir 'ni2' -> 'OpenNI2'

require 'formula'

class Openni2 < Formula
  homepage 'http://structure.io/openni'
  url 'https://github.com/occipital/OpenNI2/archive/2.2-beta2.tar.gz'
  version '2.2.0.33'
  sha1 '8c9a57de7224cd0a0a4c4bb03a7637bd179df34c'
  head 'https://github.com/occipital/OpenNI2.git'

  option :universal
  option 'with-docs', 'Build documentation using javadoc (might fail with Java 1.8)'

  depends_on :python
  depends_on 'libusb' => (build.universal?) ? ['universal'] : []
  depends_on 'doxygen' => :build if build.with? 'docs'

  def patches
    # disables javadoc documentation build by default because of errors with Java 8.
    DATA if build.without? 'docs'
  end

  def install
    ENV.universal_binary if build.universal?

    # stdlib of clang changed since mavericks
    ENV.cxx += ' -stdlib=libstdc++' if ENV.compiler == :clang && MacOS.version >= :mavericks

    system 'make', 'all'
    system 'make', 'doc' if build.with? 'docs'
    mkdir 'out'
    arch = (MacOS.version <= :leopard && !build.universal?) ? 'x86' :'x64'
    system 'python', 'Packaging/Harvest.py', 'out', arch

    cd 'out'

    (lib+'ni2').install Dir['Redist/*']
    (share+'openni2/tools').install Dir['Tools/*']
    (share+'openni2/samples').install Dir['Samples/*']
    doc.install Dir['Documentation'] if build.with? 'docs'

    # Purpleray expects to find includes in the 'OpenNI2' dir, not 'ni2'
    #(include+'ni2').install Dir['Include/*']
    (include+'OpenNI2').install Dir['Include/*']
  end

  def caveats; <<-EOS.undent
    Add the recommended variables to your dotfiles.
     * On Bash, add them to `~/.bash_profile`.
     * On Zsh, add them to `~/.zprofile` instead.

    export OPENNI2_INCLUDE=#{HOMEBREW_PREFIX}/include/OpenNI2
    export OPENNI2_REDIST=#{HOMEBREW_PREFIX}/lib/OpenNI2
    EOS
  end
end

__END__
diff --git a/Packaging/Harvest.py b/Packaging/Harvest.py
index 4ce9ed2..fad7017 100755
--- a/Packaging/Harvest.py
+++ b/Packaging/Harvest.py
@@ -312,7 +312,7 @@ $(OUTPUT_FILE): copy-redist
         
         # Documentation
         docDir = os.path.join(self.outDir, 'Documentation')
-        self.copyDocumentation(docDir)
+        #self.copyDocumentation(docDir)
         
         # Include
         shutil.copytree(os.path.join(rootDir, 'Include'), os.path.join(self.outDir, 'Include'))
