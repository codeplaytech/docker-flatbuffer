protoc_version:=3.19.4
protoc_image_tag:=$(protoc_version)-$(shell date +'%Y%m%d')
protoc_url:=https://github.com/protocolbuffers/protobuf/releases/download/v$(protoc_version)/protoc-$(protoc_version)-linux-x86_64.zip
protoc_url_cache:=http://127.0.0.1:9527/protoc-$(protoc_version)-linux-x86_64.zip


build-with-mirror:
	docker build . \
		--network host \
		--build-arg protoc_url=$(protoc_url_cache) \
		--build-arg goproxy=https://goproxy.cn,direct \
		--tag cupen/protoc:$(protoc_image_tag)


push2dockerhub:
	docker push cupen/protoc:$(protoc_image_tag)


serve-mirror:
	[ -f protoc-$(protoc_version)-linux-x86_64.zip ] || wget $(protoc_url)
	python -m http.server 9527


start:
	[ -f protoc-$(protoc_version)-linux-x86_64.zip ] || wget $(protoc_url)
	tmux new-session -d -s dp
	tmux split-window -t "dp:0"   -v
	tmux select-pane -t "dp:0.1"
	tmux send-keys -t "dp:0.0" "make serve-mirror" Enter
	tmux send-keys -t "dp:0.1" "make build-with-mirror" Enter
	# tmux send-keys -t "eg:0.2" "go run member/main.go" Enter
	tmux attach -t dp
	tmux kill-session -t dp

