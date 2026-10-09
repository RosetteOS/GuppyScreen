#include "minitest.h"
#include <unistd.h>
#include <string>

namespace KUtils {
  std::string get_mdns_hostname() {
    char hostname[256] = {0};
    if (gethostname(hostname, sizeof(hostname)) == 0 && hostname[0] != '\0') {
      return std::string(hostname) + ".local";
    }
    return "rosetteos.local";
  }
}

TEST(Mdns, resolves_local_suffix) {
  std::string mdns = KUtils::get_mdns_hostname();
  ASSERT_FALSE(mdns.empty());
  
  // Must end with .local
  std::string suffix = ".local";
  ASSERT_TRUE(mdns.size() > suffix.size());
  ASSERT_EQ(mdns.substr(mdns.size() - suffix.size()), suffix);

  // If system hostname is readable, verify prefix matches hostname
  char h[256] = {0};
  if (gethostname(h, sizeof(h)) == 0 && h[0] != '\0') {
    ASSERT_EQ(mdns, std::string(h) + ".local");
  } else {
    ASSERT_EQ(mdns, std::string("rosetteos.local"));
  }
}

int main() {
  return minitest::run_all("mdns") > 0 ? 1 : 0;
}
