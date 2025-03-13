FROM amazon/dynamodb-local:latest

USER root
# Install required tools for initialization
RUN yum update -y && \
    yum install -y curl unzip python3 && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip ./aws && \
    yum clean all

# Copy initialization script
COPY init-local-db.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-local-db.sh

# Create an entrypoint script that starts DynamoDB and runs initialization
RUN echo '#!/bin/bash\n\
# Start DynamoDB in the background\n\
java -jar DynamoDBLocal.jar -sharedDb -inMemory &\n\
# Wait for DynamoDB to start\n\
sleep 5\n\
# Run initialization script\n\
/usr/local/bin/init-local-db.sh\n\
# Keep container running\n\
tail -f /dev/null' > /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

USER dynamodblocal

# Expose DynamoDB port
EXPOSE 8000

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
