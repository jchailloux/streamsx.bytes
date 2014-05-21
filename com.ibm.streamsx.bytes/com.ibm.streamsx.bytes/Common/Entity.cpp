Entity::Entity(json_t *element){
    switch (json_typeof(element)) {
    case JSON_OBJECT:
        fprintf(stderr, "JSON type OBJECT is %d\n", json_typeof(element));
        break;
    case JSON_ARRAY:
        fprintf(stderr, "JSON type ARRAY is %d\n", json_typeof(element));
        break;
    case JSON_STRING:
        fprintf(stderr, "JSON type STRING is %d\n", json_typeof(element));
        break;
    case JSON_INTEGER:
        fprintf(stderr, "JSON type INTEGER is %d\n", json_typeof(element));
        break;
    case JSON_REAL:
        fprintf(stderr, "JSON type REAL is %d\n", json_typeof(element));
        break;
    case JSON_TRUE:
        fprintf(stderr, "JSON type TRUE is %d\n", json_typeof(element));
        break;
    case JSON_FALSE:
        fprintf(stderr, "JSON type FALSE is %d\n", json_typeof(element));
        break;
    case JSON_NULL:
        fprintf(stderr, "JSON type NULL is %d\n", json_typeof(element));
        break;
    default:
        fprintf(stderr, "unrecognized JSON type %d\n", json_typeof(element));
    }
}
