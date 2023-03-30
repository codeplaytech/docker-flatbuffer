include env

ifndef version 
$(error Missing variable "version")
endif

ifndef flatc_version 
$(error Missing variable "flatc_version")
endif


build:
	docker build . \
		--build-arg flatc_version=$(flatc_version) \
		-t flatbufers:latest


tag:
	git add env
	git commit -m "tag: $(version)"
	git tag $(version)
	git push origin master:master
	git push origin $(version)

