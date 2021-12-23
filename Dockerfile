FROM registry.access.redhat.com/ubi8/go-toolset AS build
WORKDIR /src

COPY godialme.go /src

RUN go version && GOOS=linux go build  -o /tmp/godialme godialme.go

FROM registry.access.redhat.com/ubi8/ubi

RUN yum -y install bind-utils && yum -y clean all  && rm -rf /var/cache

COPY --from=build /tmp/godialme /

ENTRYPOINT ["/godialme"]
