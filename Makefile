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

