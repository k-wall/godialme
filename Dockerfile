FROM scratch

ADD godialme ./

ENTRYPOINT ["/godialme"]
