# cp-mac: https://github.com/Paras-ydv/cp-mac
class CpMac < Formula
  desc "Make bits/stdc++.h, pb_ds and rope work with Apple Clang for competitive programming"
  homepage "https://github.com/Paras-ydv/cp-mac"
  url "https://github.com/Paras-ydv/cp-mac/archive/cd17365901198c7b87afd37bb3e44b37986bcc1f.tar.gz"
  version "1.0.0"
  sha256 "3d87aa0c9d8fd85890f050047f8f72ee51ab4ad06763eacda9e9f28be6cf5b64"
  license all_of: ["MIT", "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }]
  head "https://github.com/Paras-ydv/cp-mac.git", branch: "main"

  def install
    (buildpath/"include/cp-mac/VERSION").write version.to_s
    include.install Dir["include/*"]
    bin.install "bin/cp-mac"
    bin.install_symlink "cp-mac" => "cprun"
  end

  def caveats
    return unless HOMEBREW_PREFIX.to_s != "/usr/local"

    <<~EOS
      Apple Clang does not search #{HOMEBREW_PREFIX}/include, so run this once
      to make #include <bits/stdc++.h> work everywhere (it asks for your password):

        cp-mac link

      Then check everything with:  cp-mac doctor
    EOS
  end

  test do
    (testpath/"t.cpp").write <<~CPP
      #include <bits/stdc++.h>
      #include <ext/pb_ds/assoc_container.hpp>
      #include <ext/pb_ds/tree_policy.hpp>
      #include <ext/rope>
      using namespace std;
      using namespace __gnu_pbds;
      int main() {
        tree<int, null_type, less<int>, rb_tree_tag, tree_order_statistics_node_update> s;
        s.insert(2); s.insert(1);
        __gnu_cxx::rope<int> r; r.push_back(3);
        cout << *s.find_by_order(1) << r[0] << __gcd(4, 6) << __lg(8) << endl;
      }
    CPP
    system ENV.cxx, "-std=c++17", "-I#{include}", "t.cpp", "-o", "t"
    assert_equal "2323", shell_output("./t").strip
    assert_match version.to_s, shell_output("#{bin}/cp-mac version")
  end
end
