#include <jansson.h>

class Entity {
 public:
  int index;
  String name;
  String description;
  String unit;
  bool isSigned;
  bool isMSB;
  int word;
  int start;
  int length;
  String format;
  float factor;
  float offset;
  int limit;

 protected:
  bitset<size_t> payload;

  Entity(json_t *element);
};
