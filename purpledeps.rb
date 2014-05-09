require "formula"

class Purpledeps < Formula
  homepage "https://github.com/aharrison-dotproduct"
  url "https://raw.githubusercontent.com/aharrison-dotproduct/homebrew-deps/master/README.md"
  sha1 "b231d034cead2eb488d9648714776658a2979ff0"
  version "1.0"

  depends_on 'libcvd'
  depends_on 'toon'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'libpng'
  depends_on 'libdc1394'
  depends_on 'mono'
  depends_on 'eigen'
  depends_on 'boost'

  def install
  end

end
