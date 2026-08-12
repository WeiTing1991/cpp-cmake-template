# include/

Public headers for the project. Organized by project name and module.

```
include/
└── cpp_cmake_template/
    ├── submodule1/
    │   └── module.h
    └── submodule2/
        └── utils.h
```

Headers here are the public API — anything that other modules or external consumers need to `#include`.
Keep implementation details and private headers in `src/` alongside their `.cpp` files.

Usage: `#include "cpp_cmake_template/submodule1/module.h"`
