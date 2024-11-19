# Stage 1: Create a smaller runtime image
FROM alpine:latest

# Install certificates for HTTPS requests
RUN apk --no-cache add ca-certificates

# Set the working directory inside the container
WORKDIR /app/

# Copy the built binary from the builder stage
COPY ./bin/* .
RUN chmod -R +x /app/*

# Expose the port for the gateway service
EXPOSE 8080
EXPOSE 8082
EXPOSE 8083
EXPOSE 8084

# Command to run the gateway service
CMD ["./gateway"]
