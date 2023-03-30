FROM mcr.microsoft.com/dotnet/sdk:7.0-bullseye-slim AS build
LABEL maintainer="xcupen@gmail.com"

ARG flatc_version=v23.3.3
RUN apt-get update && \
    apt-get install -y \
        g++ git cmake make
RUN git clone --branch ${flatc_version} --depth 1 https://github.com/google/flatbuffers.git

# build flatc 
RUN cd flatbuffers \
    && cmake -G "Unix Makefiles" \
    && make

RUN dotnet --version
RUN dotnet build -m:1 -o ./flatbuffers/net/FlatBuffers/bin/Debug/ "flatbuffers/net/FlatBuffers/Google.FlatBuffers.csproj"
RUN dotnet build -m:1 -c Release -o ./flatbuffers/net/FlatBuffers/bin/Release/ "flatbuffers/net/FlatBuffers/Google.FlatBuffers.csproj"


FROM debian:bullseye-slim
COPY --from=build flatbuffers/flatc  /usr/local/bin/flatc
COPY --from=build /flatbuffers/net/FlatBuffers/bin/Release/Google.FlatBuffers.dll /dll/Release/
COPY --from=build /flatbuffers/net/FlatBuffers/bin/Debug/Google.FlatBuffers.dll   /dll/Debug/
