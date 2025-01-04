#include <glib.h>
#include <stdio.h>

int main(void) {
  g_autoptr(GString) message = g_string_new("hello");
  g_string_append(message, ", world!");
  printf("%s\n", message->str);
  return 0;
}