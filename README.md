# Usage
## Bash
```bash
docker run --rm -it ghcr.io/codeplaytech/flatbuffers:latest
```


## Makefile
```makefile
work_dir :=$(CURDIR)

flatc :=sudo docker run -it --rm \
	-v $(work_dir)/:/server \
	-w /server \
	ghcr.io/codeplaytech/flatbuffers:latest

flatc_opts :=--gen-onefile --gen-object-api --csharp

fb:
	@for f in $(shell find . -iname "*.fbs"); do \
		echo compiling $$f;  \
		$(flatc) $(flatc_opts)  $$f; \
	done
```


# Build
推送 git tag 即可自动触发 github action 构建
