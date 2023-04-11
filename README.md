# Parser

How to use

```bash
docker build . -t parser

cat EOF >> ~/bin/parser
#!/bin/bash

docker run -u $USER -v $(pwd):/home/mfrw/h -it parser:latest
EOF

chmod +x ~/bin/parser

# RUN ~/bin/parser in CM2 root directory
```
