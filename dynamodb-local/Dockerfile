FROM amazon/dynamodb-local:latest

# Install system dependencies and AWS CLI
USER root
RUN yum update -y && \
    yum install -y curl unzip && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip && \
    yum clean all && \
    rm -rf /var/cache/yum

# Create non-root user and set up directories
RUN useradd -r -g root dynamodb && \
    mkdir -p /docker-entrypoint-initdb.d && \
    chown -R dynamodb:root /home/dynamodblocal /docker-entrypoint-initdb.d

# Copy initialization script
COPY --chown=dynamodb:root init-local-db.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/init-local-db.sh

# Switch to non-root user
USER dynamodb

# Expose DynamoDB port
EXPOSE 8000

# Default to in-memory mode with shared database
CMD ["-jar", "DynamoDBLocal.jar", "-inMemory", "-sharedDb"]

